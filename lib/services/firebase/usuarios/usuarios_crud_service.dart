import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuariosCrudService extends ChangeNotifier {
  //REFERENCIA FIREBASE
  CollectionReference usuariosFirebaseReference =
      FirebaseFirestore.instance.collection('usuarios');

  UsuariosCrudService() {
    obtenerUsuarios();
  }

  //USUARIO ACTUAL
  UsuariosModel? usuarioActual = null;
  List<UsuariosModel>? listUsuarios = [];

  //CARGANDO
  bool cargandoLogin = false;

  loginUser(BuildContext context, String user, String password) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);
    final orderService = Provider.of<OrderService>(context, listen: false);
    final paymentCajaProvider =
        Provider.of<PaymentCajaProvider>(context, listen: false);
    final ordenesProvider =
        Provider.of<OrdenesProvider>(context, listen: false);

    await usuariosFirebaseReference
        .where('usuario', isEqualTo: user)
        //.where('password', isEqualTo: password)
        .get()
        .then((event) async {
      if (event.docs.isNotEmpty) {
        final _usuarioObtenido = event.docs[0].data() as Map<String, dynamic>;

        print(_usuarioObtenido);

        UsuariosModel usuarioProbable = UsuariosModel.fromMap(_usuarioObtenido);

        usuarioProbable.firebaseId = event.docs[0].id;

        print(usuarioProbable.toMap());

        //COMPROBAR CONTRASEÑA
        if (password == usuarioProbable.password) {
          okToastService.showOkToast(mensaje: 'Sesión iniciada correctamente');
          Navigator.pushNamedAndRemoveUntil(context, '/tabs', (route) => false);
        } else {
          okToastService.showOkToast(
              mensaje: 'Usuario o contraseña incorrecta');
          usuarioActual = null;
        }
      } else {
        okToastService.showOkToast(
            mensaje: 'No fue posible encontrar el usuario');
        usuarioActual = null;
      }
      notifyListeners();
    }).catchError((error) {
      print('Error: $error');
      okToastService.showOkToast(
          mensaje: 'Error, comuniquese con el administrador');
    });
  }

  agregarUsuario(BuildContext context, UsuariosModel usuario) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              content: Container(
                width: 600,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    ),
                    SpaceY(),
                    TextSmall('Generando...')
                  ],
                ),
              ),
            ),
          );
        });

    await usuariosFirebaseReference
        .where('usuario', isEqualTo: usuario.usuario)
        .get()
        .then((event) async {
      if (event.docs.isEmpty) {
        //CREAR USUARIO
        await usuariosFirebaseReference.add(usuario.toMap()).then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
          okToastService.showOkToast(mensaje: 'Usuario generado correctamente');
        }).catchError((error) {
          okToastService.showOkToast(
              mensaje: 'Error al generar, invente nuevamente');
        });
      } else {
        Navigator.pop(context);
        okToastService.showOkToast(
            mensaje: 'El nombre de usuario ya fue creado anteriormente');
      }
      notifyListeners();
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje:
              'Error al comprobar usuario, comuniquese con el administrador');
    });
  }

  editarUsuario(BuildContext context, UsuariosModel usuario) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    await usuariosFirebaseReference
        .doc(usuario.firebaseId)
        .set(usuario.toMap())
        .then((value) {
      Navigator.pop(context);
      okToastService.showOkToast(mensaje: 'Usuario actualizado correctamente');
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje: 'Error al actualizar, invente nuevamente');
    });
  }

  eliminarUsuario(BuildContext context, UsuariosModel usuario) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    await usuariosFirebaseReference
        .doc(usuario.firebaseId)
        .delete()
        .then((value) {
      Navigator.pop(context);
      okToastService.showOkToast(mensaje: 'Usuario eliminado correctamente');
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje: 'Error al eliminar, invente nuevamente ');
      print('Error: ${error.toString()}');
    });
  }

  obtenerUsuarios() {
    return usuariosFirebaseReference.snapshots().listen((event) {
      final _listaDocumentos = event.docs;

      print(_listaDocumentos.length);

      _listaDocumentos.map((e) => {});

      List<UsuariosModel> listProductosProv = _listaDocumentos.map((doc) {
        UsuariosModel inventarioItemProv =
            UsuariosModel.fromMap(doc.data() as Map<String, dynamic>);

        inventarioItemProv.firebaseId = doc.id;

        return inventarioItemProv;
      }).toList();

      listUsuarios = listProductosProv;

      print(listUsuarios!.length);

      notifyListeners();

      print('Actualizacion obtenida de Usuarios');
    });
  }
}

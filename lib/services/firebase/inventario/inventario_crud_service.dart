import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/oktoast/oktoast_service.dart';
import 'package:allegro_saludable/views/ajustes/subpages/inventario/ajustes_inventario_provider.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class InventarioCrudService extends ChangeNotifier {
  //REFERENCIA FIREBASE
  CollectionReference inventarioFirebaseReference =
      FirebaseFirestore.instance.collection('inventario');

  bool cargandoProductos = true;

  //INVENTARIO LIST
  List<ProductoModel> listInventario = [];

  InventarioCrudService() {
    obtenerInventario();
  }

  obtenerInventario() async {
    return inventarioFirebaseReference
        .orderBy('nombre')
        .snapshots()
        .listen((event) {
      cargandoProductos = false;

      final _listaDocumentos = event.docs;

      //print(_listaDocumentos.length);

      _listaDocumentos.map((e) => {});

      List<ProductoModel> listProductosProv = _listaDocumentos.map((doc) {
        ProductoModel inventarioItemProv =
            ProductoModel.fromMap(doc.data() as Map<String, dynamic>);

        inventarioItemProv.firebaseId = doc.id;

        return inventarioItemProv;
      }).toList();

      listInventario = listProductosProv;

      notifyListeners();

      print('Actualizacion obtenida de Menu');
    });
  }

  agregarProducto(BuildContext context, ProductoModel modelo) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    await inventarioFirebaseReference.add(modelo.toMap()).then((value) {
      Navigator.pop(context);
      okToastService.showOkToast(mensaje: 'Producto generado correctamente');
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje: 'Error al generar, invente nuevamente');
    });
  }

  eliminarProducto(BuildContext context, ProductoModel modelo) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    await inventarioFirebaseReference
        .doc(modelo.firebaseId)
        .delete()
        .then((value) {
      Navigator.pop(context);
      okToastService.showOkToast(mensaje: 'Producto eliminado correctamente');
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje: 'Error al eliminar, invente nuevamente ');
      print('Error: ${error.toString()}');
    });
  }

  editarProducto(BuildContext context, ProductoModel modelo) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    await inventarioFirebaseReference
        .doc(modelo.firebaseId)
        .set(modelo.toMap())
        .then((value) {
      Navigator.pop(context);
      okToastService.showOkToast(mensaje: 'Producto actualizado correctamente');
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje: 'Error al actualizar, invente nuevamente');
    });
  }
}

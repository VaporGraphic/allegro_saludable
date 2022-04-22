import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/ordenes/ordenes_provider.dart';
import 'package:allegro_saludable/views/payment/subpages/caja/payment_caja_provider.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CajaCrudService extends ChangeNotifier {
  //REFERENCIA FIREBASE
  CollectionReference cajaFirebaseReference =
      FirebaseFirestore.instance.collection('cajaActual');
  CajaModel? cajaActual = null;

  bool cargandoCajas = true;

  CajaCrudService() {
    obtenerCaja();
  }

  obtenerCaja() async {
    return cajaFirebaseReference.doc('cajaActual').snapshots().listen((event) {
      cargandoCajas = false;

      if (event.data() != null) {
        final _cajaActual = event.data() as Map<String, dynamic>;
        cajaActual = CajaModel.fromMap(_cajaActual);
        cajaActual!.listOrdenes!.sort((a, b) => b.fecha!.compareTo(a.fecha!));
      } else {
        print('Caja vacia');
        cajaActual = null;
      }

      notifyListeners();

      print('Actualizacion obtenida de Caja');
    });
  }

  crearCaja(BuildContext context, double dineroInicial) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    CajaModel cajaNueva = CajaModel(
        dineroInicial: dineroInicial,
        firebaseId: null,
        fecha: DateTime.now(),
        listOrdenes: [],
        listPagos: [],
        subtotalOrdenes: 0,
        subtotalPagos: 0,
        total: 0);

    await cajaFirebaseReference
        .doc('cajaActual')
        .set(actualizarTotal(cajaNueva).toMap())
        .then((value) {
      Navigator.pop(context);
      okToastService.showOkToast(
          mensaje:
              'Caja iniciada correctamente a las ${DateTime.now().hour}:${DateTime.now().minute}');
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje: 'Error al iniciar caja, invente nuevamente');
    });
  }

  cerrarCaja(BuildContext context) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    CollectionReference historialCajaFirebaseReference =
        FirebaseFirestore.instance.collection('historialCajas');

    await historialCajaFirebaseReference
        .add(cajaActual!.toMap())
        .then((value) async {
      await cajaFirebaseReference.doc('cajaActual').delete().then((value) {
        Navigator.pop(context);
        okToastService.showOkToast(
            mensaje:
                'Caja cerrada correctamente a las ${DateTime.now().hour}:${DateTime.now().minute}');
      }).catchError((error) {
        okToastService.showOkToast(
            mensaje: 'Error al cerrar caja, invente nuevamente');
      });
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje: 'Error al cerrar caja, invente nuevamente');
    });
  }

//-------------------------- ORDEN --------------------------

  crearOrdenCaja(BuildContext context, OrderModel ordenModelo) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);
    final orderService = Provider.of<OrderService>(context, listen: false);
    final paymentCajaProvider =
        Provider.of<PaymentCajaProvider>(context, listen: false);
    final ordenesProvider =
        Provider.of<OrdenesProvider>(context, listen: false);

    await cajaFirebaseReference.doc('cajaActual').get().then((event) async {
      cargandoCajas = false;

      if (event.data() != null) {
        final _cajaActual = event.data() as Map<String, dynamic>;

        CajaModel cajaActualizar = CajaModel.fromMap(_cajaActual);

        ordenModelo.fecha = DateTime.now();
        ordenModelo.firebaseId = cajaActualizar.listOrdenes!.length.toString();

        cajaActualizar.listOrdenes!.add(ordenModelo);

        cajaActual = actualizarTotal(cajaActualizar);

        await cajaFirebaseReference
            .doc('cajaActual')
            .set(cajaActual!.toMap())
            .then((value) {
          okToastService.showOkToast(mensaje: 'Orden creada correctamente');

          orderService.ordenActual = ordenModelo;

          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const PaymentSuccessView()),
            ModalRoute.withName('/'),
          );

          //NAVIGATOR POP
        }).catchError((error) {
          okToastService.showOkToast(
              mensaje: 'Error al crear orden, invente nuevamente');
          Navigator.pop(context);
        });
      } else {
        okToastService.showOkToast(
            mensaje: 'Caja cerrada, inicia antes de crear la orden ');
        print('Caja vacia');
        cajaActual = null;
        Navigator.pop(context);
        ordenesProvider.abrirCaja(context);
      }

      notifyListeners();

      print('Actualizacion obtenida de Caja');
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje:
              'Error al obtener ultima version de la caja, invente nuevamente');
    });
  }

  cancelarOrden(
      {required BuildContext context,
      String? cajaFirebaseId,
      required String orderFirebaseId,
      required bool cajaActual}) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);
    final orderService = Provider.of<OrderService>(context, listen: false);

    if (cajaActual == true) {
      await cajaFirebaseReference.doc('cajaActual').get().then((event) async {
        cargandoCajas = false;

        final _cajaActual = event.data() as Map<String, dynamic>;

        CajaModel cajaActualizarProvisional = CajaModel.fromMap(_cajaActual);

        for (var i = 0;
            i < cajaActualizarProvisional.listOrdenes!.length;
            i++) {
          if (cajaActualizarProvisional.listOrdenes![i].firebaseId ==
              orderFirebaseId) {
            cajaActualizarProvisional.listOrdenes![i].estadoPedido =
                'cancelado';
          }
        }

        cajaActualizarProvisional = actualizarTotal(cajaActualizarProvisional);

        await cajaFirebaseReference
            .doc('cajaActual')
            .set(cajaActualizarProvisional.toMap())
            .then((value) {
          okToastService.showOkToast(mensaje: 'Orden cancelada correctamente');

          Navigator.pop(context);

          //NAVIGATOR POP
        }).catchError((error) {
          okToastService.showOkToast(
              mensaje: 'Error al cancelar orden, invente nuevamente');
          Navigator.pop(context);
        });

        notifyListeners();

        print('Actualizacion obtenida de Caja');
      }).catchError((error) {
        okToastService.showOkToast(
            mensaje:
                'Error al obtener ultima version de la caja, invente nuevamente');
      });
    } else {
      await cajaFirebaseReference.doc(cajaFirebaseId).get().then((event) async {
        cargandoCajas = false;

        final _cajaActual = event.data() as Map<String, dynamic>;

        CajaModel cajaActualizarProvisional = CajaModel.fromMap(_cajaActual);

        for (var i = 0;
            i < cajaActualizarProvisional.listOrdenes!.length;
            i++) {
          if (cajaActualizarProvisional.listOrdenes![i].firebaseId ==
              orderFirebaseId) {
            cajaActualizarProvisional.listOrdenes![i].estadoPedido =
                'cancelado';
          }
        }

        cajaActualizarProvisional = actualizarTotal(cajaActualizarProvisional);

        await cajaFirebaseReference
            .doc('cajaActual')
            .set(cajaActualizarProvisional.toMap())
            .then((value) {
          okToastService.showOkToast(mensaje: 'Orden cancelada correctamente');

          Navigator.pop(context);

          //NAVIGATOR POP
        }).catchError((error) {
          okToastService.showOkToast(
              mensaje: 'Error al cancelar orden, invente nuevamente');
          Navigator.pop(context);
        });

        notifyListeners();

        print('Actualizacion obtenida de Caja');
      }).catchError((error) {
        okToastService.showOkToast(
            mensaje:
                'Error al obtener ultima version de la caja, invente nuevamente');
      });
    }
  }

//-------------------------- PAGO --------------------------

  crearPagoCaja(
      BuildContext context, PagoServicioModel pagoServicioModel) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);
    final orderService = Provider.of<OrderService>(context, listen: false);
    final paymentCajaProvider =
        Provider.of<PaymentCajaProvider>(context, listen: false);
    final ordenesProvider =
        Provider.of<OrdenesProvider>(context, listen: false);

    await cajaFirebaseReference.doc('cajaActual').get().then((event) async {
      cargandoCajas = false;

      if (event.data() != null) {
        final _cajaActual = event.data() as Map<String, dynamic>;

        CajaModel cajaActualizar = CajaModel.fromMap(_cajaActual);

        pagoServicioModel.fecha = DateTime.now();
        pagoServicioModel.firebaseId =
            cajaActualizar.listPagos!.length.toString();

        cajaActualizar.listPagos!.add(pagoServicioModel);

        cajaActual = actualizarTotal(cajaActualizar);

        await cajaFirebaseReference
            .doc('cajaActual')
            .set(cajaActual!.toMap())
            .then((value) {
          okToastService.showOkToast(mensaje: 'Pago creado correctamente');

          Navigator.pop(context);

          //NAVIGATOR POP
        }).catchError((error) {
          okToastService.showOkToast(
              mensaje: 'Error al crear pago, invente nuevamente');
          Navigator.pop(context);
        });
      } else {
        okToastService.showOkToast(
            mensaje: 'Caja cerrada, inicia antes de crear la orden ');
        print('Caja vacia');
        cajaActual = null;
        Navigator.pop(context);
        ordenesProvider.abrirCaja(context);
      }

      notifyListeners();

      print('Actualizacion obtenida de Caja');
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje:
              'Error al obtener ultima version de la caja, invente nuevamente');
    });
  }

  actualizarEstadoPago(BuildContext context, String firebaseId) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    int index = cajaActual!.listPagos!.indexWhere(
        (PagoServicioModel element) => element.firebaseId == firebaseId);

    print('antes ${cajaActual!.listPagos![index].toMap()}');

    cajaActual!.listPagos![index].cancelado = true;

    print('despues ${cajaActual!.listPagos![index].toMap()}');

    actualizarTotal(cajaActual!);

    await cajaFirebaseReference
        .doc('cajaActual')
        .set(cajaActual!.toMap())
        .then((value) {
      okToastService.showOkToast(mensaje: 'Pago creado correctamente');

      Navigator.pop(context);

      //NAVIGATOR POP
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje: 'Error al crear pago, invente nuevamente');
      Navigator.pop(context);
    });
  }

//-------------------------- PAGO --------------------------

  CajaModel actualizarTotal(CajaModel cajaEditable) {
    double totalOrdenes = 0;
    double totalPagos = 0;

    for (var ordenes in cajaEditable.listOrdenes!) {
      if (ordenes.estadoPedido != 'cancelado') {
        totalOrdenes += ordenes.totalPrecio!;
      }
    }

    for (var pagos in cajaEditable.listPagos!) {
      if (pagos.cancelado == false) {
        totalPagos += pagos.totalPrecio!;
      }
    }

    cajaEditable.subtotalOrdenes = totalOrdenes;

    cajaEditable.subtotalPagos = totalPagos;

    cajaEditable.total = cajaEditable.subtotalOrdenes! +
        cajaEditable.dineroInicial! -
        cajaEditable.subtotalPagos!;

    return cajaEditable;
  }
}

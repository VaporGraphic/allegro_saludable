import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentProvider extends ChangeNotifier {
  //SWITCH RESUMEN
  bool switchResumen = true;

  //MESAS
  List<String> ubicacionEntregas = [
    'Entrega en mostrador',
    for (var i = 1; i < 10; i++) 'Mesa $i',
  ];

  //EDITORES DE TEXTO

  TextEditingController clienteController = TextEditingController();
  FocusNode clienteFocus = FocusNode();

  TextEditingController envioController = TextEditingController();
  FocusNode envioFocus = FocusNode();

  TextEditingController ubicacionController = TextEditingController();
  FocusNode ubicacionFocus = FocusNode();

  TextEditingController numeroController = TextEditingController();
  FocusNode numeroFocus = FocusNode();

  toggleResumen() {
    switchResumen = !switchResumen;
    print(switchResumen);
    notifyListeners();
  }

  abrirCaja(BuildContext context, OrderModel orden) {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    bool errorCounter = false;

    if (orden.cliente!.isEmpty) {
      okToastService.showOkToast(mensaje: 'Escribir nombre del cliente');
      clienteFocus.requestFocus();
      errorCounter = true;
    } else if (orden.switchEnvio == true) {
      if (orden.ubicacion!.isEmpty) {
        okToastService.showOkToast(mensaje: 'Escribe la ubicacion');
        ubicacionFocus.requestFocus();
        errorCounter = true;
      } else if (orden.numero == null) {
        okToastService.showOkToast(mensaje: 'Escribe el numero telefonico');
        numeroFocus.requestFocus();
        errorCounter = true;
      }
    } else {
      if (orden.ubicacionLocal!.isEmpty) {
        okToastService.showOkToast(mensaje: 'Selecciona el punto de entrega');
        mostrarModalSheet(context);
        errorCounter = true;
      }
    }

    print(errorCounter);
    if (errorCounter == false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaymentCajaView()),
      );
    }
  }

  actualizarInputs(BuildContext context) {
    final orderService = Provider.of<OrderService>(context, listen: false);

    //ACTUALIZAR NOMBRE DE CLIENTA
    orderService.ordenActual.cliente = clienteController.text;

    if (orderService.ordenActual.switchEnvio == true) {
      //ACTUALIZAR COSTO ENVIO
      if (envioController.text.isNotEmpty) {
        orderService.ordenActual.envioPrecio =
            double.parse(envioController.text);
      } else {
        orderService.ordenActual.envioPrecio = 0;
      }

      //ACTUALIZAR UBICACION
      orderService.ordenActual.ubicacion = ubicacionController.text;

      //ACTUALIZAR NUMERO
      if (numeroController.text.isNotEmpty) {
        orderService.ordenActual.numero = int.parse(numeroController.text);
      } else {
        orderService.ordenActual.numero = null;
      }
    }

    orderService.actualizarPrecio();

    notifyListeners();
  }

  mostrarModalSheet(BuildContext context) {
    final orderService = Provider.of<OrderService>(context, listen: false);

    showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            height: 600,
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpaceY(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextLead('Punto de entrega'),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close_rounded))
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                      child:
                          ListView(physics: BouncingScrollPhysics(), children: [
                    for (var ubicacion in ubicacionEntregas)
                      TextButton(
                          style:
                              TextButton.styleFrom(padding: EdgeInsets.all(15)),
                          onPressed: () {
                            orderService.ordenActual.ubicacionLocal =
                                '$ubicacion';
                            notifyListeners();
                            Navigator.pop(context);
                          },
                          child: TextNormal(
                            '$ubicacion',
                            fontWeight:
                                orderService.ordenActual.ubicacionLocal !=
                                        ubicacion
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                          )),
                    SpaceY(
                      percent: 2,
                    )
                  ])),
                ],
              ),
            ),
          );
        });
  }

  resetInputs() {}
}

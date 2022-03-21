import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentCajaProvider extends ChangeNotifier {
  //PAYMENT STRING
  String paymentString = '0';
  //CONTROLLER

  TextEditingController referenciaController = TextEditingController();

  pressButton(BuildContext context, String button) {
    final orderService = Provider.of<OrderService>(context, listen: false);

    print(button);

    if (button == 'return') {
      print('Eliminar');
      if (paymentString != null && paymentString.length > 0) {
        paymentString = paymentString.substring(0, paymentString.length - 1);
      }
      if (paymentString.isEmpty) {
        paymentString = '0';
      }
    } else {
      if (paymentString == '0' && button != '.') {
        paymentString = '';
      }
      paymentString = paymentString + button;
    }

    orderService.ordenActual.efectivoRecibido = double.parse(paymentString);
    orderService.ordenActual.cambioEntregado =
        orderService.ordenActual.efectivoRecibido! -
            orderService.ordenActual.totalPrecio!;

    if (orderService.ordenActual.cambioEntregado! < 0) {
      orderService.ordenActual.cambioEntregado = 0;
    }

    notifyListeners();
  }

  resetEfectivo(BuildContext context) {
    final orderService = Provider.of<OrderService>(context, listen: false);
    paymentString = '0';
    orderService.ordenActual.efectivoRecibido = 0;
    orderService.ordenActual.cambioEntregado = 0;
    Navigator.pop(context);
    notifyListeners();
  }

  actualizarReferenciaPago(BuildContext context) {
    final orderService = Provider.of<OrderService>(context, listen: false);
    orderService.ordenActual.referenciaTarjeta = referenciaController.text;
    notifyListeners();
  }

  revisarPago(BuildContext context) {
    final orderService = Provider.of<OrderService>(context, listen: false);
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    bool errores = false;

    if (orderService.ordenActual.switchTarjeta == false) {
      if (orderService.ordenActual.efectivoRecibido! <
          orderService.ordenActual.totalPrecio!) {
        okToastService.showOkToast(
            mensaje: 'El efectivo recibido es menor al total de la orden');

        errores = true;
      }
    } else {
      if (referenciaController.text.isEmpty) {
        okToastService.showOkToast(
            mensaje: 'Escribe la referencia del pago con tarjeta');
        errores = true;
      }
    }

    if (errores == false) {
      mostrarModalRevision(context);
    }
  }

  mostrarModalRevision(BuildContext context) {
    final orderService = Provider.of<OrderService>(context, listen: false);

    List<Widget> datosEnvio = [
      SpaceY(
        percent: .5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextNormal(
            'Ubicacion entrega:',
            color: Colors.grey,
          ),
          TextNormal('${orderService.ordenActual.ubicacion}')
        ],
      ),
      SpaceY(
        percent: .5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextNormal(
            'Telefono referencia',
            color: Colors.grey,
          ),
          TextNormal('${orderService.ordenActual.numero}')
        ],
      ),
      SpaceY(
        percent: .5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextNormal(
            'Costo envio:',
            color: Colors.grey,
          ),
          TextNormal('\$${orderService.ordenActual.envioPrecio}')
        ],
      ),
    ];

    List<Widget> datosLocal = [
      SpaceY(
        percent: .5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextNormal(
            'Mesa:',
            color: Colors.grey,
          ),
          TextNormal('${orderService.ordenActual.ubicacionLocal}')
        ],
      ),
    ];

    showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            height: double.infinity,
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
                        Expanded(child: TextLead('Revisar orden')),
                        InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: const EdgeInsets.all(7.5),
                              child: Icon(Icons.close_rounded),
                            ))
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(15),
                    child:
                        ListView(physics: BouncingScrollPhysics(), children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextNormal(
                            'Cliente:',
                            color: Colors.grey,
                          ),
                          TextNormal('${orderService.ordenActual.cliente}')
                        ],
                      ),
                      if (orderService.ordenActual.switchEnvio == true)
                        ...datosEnvio
                      else
                        ...datosLocal,
                      SpaceY(
                        percent: .5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextNormal(
                            'Subtotal:',
                            color: Colors.grey,
                          ),
                          TextNormal(
                              '\$${orderService.ordenActual.subtotalPrecio}')
                        ],
                      ),
                      SpaceY(
                        percent: .5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextNormal(
                            'Total:',
                          ),
                          TextLead('\$${orderService.ordenActual.totalPrecio}')
                        ],
                      ),
                      Divider(),
                      SpaceY(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextNormal(
                            'Productos seleccionados:',
                            color: Colors.grey,
                          ),
                          TextNormal(
                              '${orderService.ordenActual.itemsList!.length}')
                        ],
                      ),
                      SpaceY(),
                      for (var producto in orderService.ordenActual.itemsList!)
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextNormal(
                                    '(${producto.cantidad!}) ${producto.nombre!} ${producto.modeloSeleccionado!.subnombre}',
                                    color: Colors.grey,
                                    maxLines: 2,
                                  ),
                                ),
                                SpaceX(
                                  percent: .5,
                                ),
                                TextNormal('\$${producto.totalPrecio!}')
                              ],
                            ),
                          ],
                        )
                    ]),
                  )),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_outlined),
                            SpaceX(
                              percent: .5,
                            ),
                            TextNormal(
                              'Crear orden',
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }
}

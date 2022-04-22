import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentCajaProvider extends ChangeNotifier {
  //PAYMENT STRING
  String paymentString = '0';

  bool switchOrdenLoading = false;
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
      if (double.parse(paymentString) == 0 && button != '.') {
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

  establecerCaja(BuildContext context) {
    final orderService = Provider.of<OrderService>(context, listen: false);
    paymentString = orderService.ordenActual.efectivoRecibido.toString();
    referenciaController.clear();
    orderService.ordenActual.referenciaTarjeta = '';
    if (paymentString == '0.0') {
      paymentString = '0';
    }
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
      if (orderService.ordenActual.referenciaTarjeta!.isEmpty) {
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
    final printerService = Provider.of<PrinterService>(context, listen: false);
    final cajaCrudService =
        Provider.of<CajaCrudService>(context, listen: false);

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

    List<Widget> datosEfectivo = [
      SpaceY(
        percent: .5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextNormal(
            'Efectivo recibido:',
            color: Colors.grey,
          ),
          TextNormal('${orderService.ordenActual.efectivoRecibido}')
        ],
      ),
      SpaceY(
        percent: .5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextNormal(
            'Cambio entregado:',
            color: Colors.grey,
          ),
          TextNormal('${orderService.ordenActual.cambioEntregado}')
        ],
      ),
    ];

    List<Widget> datosTarjeta = [
      SpaceY(
        percent: .5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextNormal(
            'Referencia tarjeta:',
            color: Colors.grey,
          ),
          TextNormal('${orderService.ordenActual.referenciaTarjeta}')
        ],
      ),
    ];

    showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SpaceY(
                  percent: 4,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
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
                            child: ListView(
                                physics: BouncingScrollPhysics(),
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextNormal(
                                        'Cliente:',
                                        color: Colors.grey,
                                      ),
                                      TextNormal(
                                          '${orderService.ordenActual.cliente}')
                                    ],
                                  ),
                                  if (orderService.ordenActual.switchEnvio ==
                                      true)
                                    ...datosEnvio
                                  else
                                    ...datosLocal,
                                  SpaceY(
                                    percent: .5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextNormal(
                                        'Subtotal:',
                                        color: Colors.grey,
                                      ),
                                      TextNormal(
                                          '\$${orderService.ordenActual.subtotalPrecio}')
                                    ],
                                  ),
                                  if (orderService.ordenActual.switchTarjeta ==
                                      false)
                                    ...datosEfectivo
                                  else
                                    ...datosTarjeta,
                                  SpaceY(
                                    percent: .5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextNormal(
                                        'Total:',
                                      ),
                                      TextLead(
                                        '\$${orderService.ordenActual.totalPrecio}',
                                        fontWeight: FontWeight.bold,
                                      )
                                    ],
                                  ),
                                  Divider(),
                                  SpaceY(),
                                  Row(
                                    children: [
                                      TextNormal(
                                        'Productos seleccionados:',
                                      ),
                                      SpaceX(
                                        percent: .5,
                                      ),
                                      TextNormal(
                                          '${orderService.ordenActual.itemsList!.length}')
                                    ],
                                  ),
                                  SpaceY(),
                                  for (var producto
                                      in orderService.ordenActual.itemsList!)
                                    Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextSmall(
                                                        'Cantidad: ${producto.cantidad!}',
                                                        color: Colors.grey,
                                                      ),
                                                      TextNormal(
                                                        'Costo \$${producto.totalPrecio!}',
                                                      )
                                                    ],
                                                  ),
                                                  TextNormal(
                                                    '${producto.nombre!} ${producto.modeloSeleccionado!.subnombre} - \$${producto.modeloSeleccionado!.precio}',
                                                    color: Colors.black
                                                        .withOpacity(.70),
                                                    maxLines: 10,
                                                  ),
                                                  for (var complemento
                                                      in producto
                                                          .listComplementos!)
                                                    if (complemento
                                                            .seleccionado ==
                                                        true)
                                                      TextSmall(
                                                        '    -${complemento.complementoData.nombre}',
                                                        color: Colors.grey,
                                                      ),
                                                  for (var extra
                                                      in producto.listExtras!)
                                                    if (extra.cantidad > 0)
                                                      TextSmall(
                                                        '    -(x${extra.cantidad}) ${extra.extraData.nombre} - ${extra.subtotal}',
                                                        color: Colors.grey,
                                                      )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7.5),
                                          child: Divider(
                                            color: Colors.grey.shade100,
                                          ),
                                        )
                                      ],
                                    )
                                ]),
                          )),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          alignment: Alignment.center,
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SpaceY(),
                                              CircularProgressIndicator(),
                                              SpaceY(),
                                              TextNormal('Generando orden')
                                            ],
                                          ),
                                        );
                                      });
                                  //ASD
                                  cajaCrudService.crearOrdenCaja(
                                      context, orderService.ordenActual);
                                },
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
                  ),
                ),
              ],
            ),
          );
        });
  }
}

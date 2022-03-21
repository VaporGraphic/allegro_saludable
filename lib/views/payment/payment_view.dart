import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/payment/widgets/expanded_button.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/widgets/appbar/appbar_widget.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderService = Provider.of<OrderService>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);

    List<Widget> formLocal = [
      Ink(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(.5),
              ),
              borderRadius: BorderRadius.circular(15)),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              paymentProvider.mostrarModalSheet(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.volunteer_activism_outlined,
                    color: Colors.grey,
                  ),
                  SpaceX(),
                  Expanded(
                      child: orderService.ordenActual.ubicacionLocal!.isEmpty
                          ? Text(
                              'Elegir punto de entrega',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            )
                          : Text(
                              '${orderService.ordenActual.ubicacionLocal}',
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 16,
                              ),
                            )),
                  SpaceX(),
                  Icon(
                    Icons.expand_less_outlined,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ))
    ];

    List<Widget> formEnvio = [
      TextField(
        focusNode: paymentProvider.envioFocus,
        controller: paymentProvider.envioController,
        onChanged: (value) {
          paymentProvider.actualizarInputs(context);
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.monetization_on_outlined),
            hintText: 'Costo de envio'),
      ),
      SpaceY(),
      TextField(
        focusNode: paymentProvider.ubicacionFocus,
        controller: paymentProvider.ubicacionController,
        onChanged: (value) {
          paymentProvider.actualizarInputs(context);
        },
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.place_outlined), hintText: 'Ubicacion'),
      ),
      SpaceY(),
      TextField(
        focusNode: paymentProvider.numeroFocus,
        controller: paymentProvider.numeroController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        onChanged: (value) {
          paymentProvider.actualizarInputs(context);
        },
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone_android_outlined),
            hintText: 'Numero de referencia'),
      ),
    ];

    List<Widget> resumenOrden = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextNormal(
            'Subtotal (2 productos) :',
            color: Colors.grey,
          ),
          TextNormal(
            '\$${orderService.ordenActual.subtotalPrecio}',
          ),
        ],
      ),
      orderService.ordenActual.switchEnvio == true
          ? SpaceY(
              percent: .5,
            )
          : Container(),
      orderService.ordenActual.switchEnvio == true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextNormal(
                  'Envio:',
                  color: Colors.grey,
                ),
                TextNormal(
                  '\$${orderService.ordenActual.envioPrecio}',
                ),
              ],
            )
          : Container(),
      Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextNormal(
            'Total:',
          ),
          TextLead(
            '\$${orderService.ordenActual.totalPrecio}',
          ),
        ],
      ),
      SpaceY(),
    ];

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Crear orden',
        leading: IconButton(
            onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(15),
                children: [
                  TextTitle('Crear nueva orden'),
                  Text('Rellena los datos'),
                  SpaceY(),
                  TextField(
                    focusNode: paymentProvider.clienteFocus,
                    controller: paymentProvider.clienteController,
                    onChanged: (value) {
                      paymentProvider.actualizarInputs(context);
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.sentiment_satisfied_alt_rounded),
                        hintText: 'Nombre del cliente'),
                  ),

                  SpaceY(),
                  if (orderService.ordenActual.switchEnvio == true)
                    ...formEnvio
                  else
                    ...formLocal,

                  SpaceY(),

                  //else  ...formLocal
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.20),
                    spreadRadius: 2,
                    blurRadius: 7.5,
                    offset: Offset(0, 0), // changes position of shadow
                  )
                ],
                color: Colors.white,
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextLead('Resumen orden'),
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              paymentProvider.toggleResumen();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(7.5),
                              child: Icon(
                                paymentProvider.switchResumen == false
                                    ? Icons.expand_less_outlined
                                    : Icons.expand_more_outlined,
                                color: Colors.grey.withOpacity(.5),
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 150),
                        child: paymentProvider.switchResumen == true
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [...resumenOrden],
                              )
                            : Container(),
                      ),
                      Row(
                        children: [
                          ExpandedButton(
                            icon: Icons.storefront,
                            title: 'Orden local',
                            subtitle: 'En negocio',
                            onTap: () {
                              orderService.toogleEnvio(false);
                            },
                            selected:
                                orderService.ordenActual.switchEnvio == false,
                          ),
                          SpaceX(
                            percent: .5,
                          ),
                          ExpandedButton(
                            icon: Icons.pedal_bike_outlined,
                            title: 'Envio',
                            subtitle: 'Entregar',
                            onTap: () {
                              orderService.toogleEnvio(true);
                            },
                            selected:
                                orderService.ordenActual.switchEnvio == true,
                          ),
                        ],
                      ),
                      SpaceY(),
                      ElevatedButton(
                          onPressed: () {
                            paymentProvider.abrirCaja(
                                context, orderService.ordenActual);
                          },
                          child: TextNormal(
                            'Proceder a caja',
                            fontWeight: FontWeight.bold,
                          ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

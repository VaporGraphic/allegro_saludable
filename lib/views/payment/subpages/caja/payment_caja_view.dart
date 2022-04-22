import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/payment/widgets/expanded_button.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/widgets/appbar/appbar_widget.dart';
import 'package:allegro_saludable/widgets/spacing/space_widgets.dart';
import 'package:allegro_saludable/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentCajaView extends StatelessWidget {
  const PaymentCajaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentCajaProvider = Provider.of<PaymentCajaProvider>(context);
    final orderService = Provider.of<OrderService>(context);

    List<Widget> efectivoCaja = [
      TextLead('Total: \$${orderService.ordenActual.totalPrecio}'),
      SpaceY(
        percent: .5,
      ),
      Text(
        '${paymentCajaProvider.paymentString}',
        style: TextStyle(fontSize: 45),
      ),
      SpaceY(
        percent: .5,
      ),
      Text(
        'Cambio: \$${orderService.ordenActual.cambioEntregado}',
      ),
      SpaceY(),
      Container(
        width: 400,
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 7 / 4,
          shrinkWrap: true,
          crossAxisCount: 3,
          children: [
            TextButton(
                onPressed: () {
                  paymentCajaProvider.pressButton(context, '1');
                },
                child: TextTitle('1')),
            TextButton(
                onPressed: () {
                  paymentCajaProvider.pressButton(context, '2');
                },
                child: TextTitle('2')),
            TextButton(
                onPressed: () {
                  paymentCajaProvider.pressButton(context, '3');
                },
                child: TextTitle('3')),
            TextButton(
                onPressed: () {
                  paymentCajaProvider.pressButton(context, '4');
                },
                child: TextTitle('4')),
            TextButton(
                onPressed: () {
                  paymentCajaProvider.pressButton(context, '5');
                },
                child: TextTitle('5')),
            TextButton(
                onPressed: () {
                  paymentCajaProvider.pressButton(context, '6');
                },
                child: TextTitle('6')),
            TextButton(
                onPressed: () {
                  paymentCajaProvider.pressButton(context, '7');
                },
                child: TextTitle('7')),
            TextButton(
                onPressed: () {
                  paymentCajaProvider.pressButton(context, '8');
                },
                child: TextTitle('8')),
            TextButton(
                onPressed: () {
                  paymentCajaProvider.pressButton(context, '9');
                },
                child: TextTitle('9')),
            TextButton(
                onPressed: () {
                  paymentCajaProvider.pressButton(context, '.');
                },
                child: TextTitle('.')),
            TextButton(
                onPressed: () {
                  paymentCajaProvider.pressButton(context, '0');
                },
                child: TextTitle('0')),
            TextButton(
                onPressed: () {
                  paymentCajaProvider.pressButton(context, 'return');
                },
                child: Icon(Icons.backspace_outlined))
          ],
        ),
      )
    ];

    List<Widget> efectivoTarjeta = [
      TextLead('Total a pagar: \$${orderService.ordenActual.totalPrecio}'),
      SpaceY(),
      TextNormal('Informacion del pago'),
      SpaceY(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          autofocus: true,
          controller: paymentCajaProvider.referenciaController,
          onChanged: (value) {
            paymentCajaProvider.actualizarReferenciaPago(context);
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.payment_outlined),
              hintText: 'Referencia de pago'),
        ),
      )
    ];

    return WillPopScope(
      onWillPop: () async {
        paymentCajaProvider.resetEfectivo(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBarWidget(
          title: orderService.ordenActual.switchTarjeta == false
              ? 'Caja efectivo'
              : 'Caja tarjeta',
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (orderService.ordenActual.switchTarjeta == false)
                      ...efectivoCaja
                    else
                      ...efectivoTarjeta
                  ],
                ),
              )),
              Container(
                padding: EdgeInsets.all(15),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          ExpandedButton(
                              icon: Icons.payments_outlined,
                              title: 'Efectivo',
                              subtitle: 'Recibir monedas',
                              onTap: () {
                                orderService.toogleTarjeta(false);
                              },
                              selected:
                                  orderService.ordenActual.switchTarjeta ==
                                      false),
                          SpaceX(
                            percent: .5,
                          ),
                          ExpandedButton(
                              icon: Icons.payment_outlined,
                              title: 'Tarjeta',
                              subtitle: 'Info pago',
                              onTap: () {
                                orderService.toogleTarjeta(true);
                              },
                              selected:
                                  orderService.ordenActual.switchTarjeta ==
                                      true),
                        ],
                      ),
                    ),
                    SpaceY(),
                    ElevatedButton(
                        onPressed: () {
                          paymentCajaProvider.revisarPago(context);
                        },
                        child: TextNormal(
                          'Revisar orden',
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

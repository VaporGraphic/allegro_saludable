import 'package:allegro_saludable/services/order/order_service.dart';
import 'package:allegro_saludable/services/printer/printer_service.dart';
import 'package:allegro_saludable/views/ordenes/ordenes_provider.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderService = Provider.of<OrderService>(context);
    final paymentSuccessProvider = Provider.of<PaymentSuccessProvider>(context);
    final printerService = Provider.of<PrinterService>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/tabs', (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBarWidget(
          title: 'Exito',
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(15),
                  children: [
                    TextTitle(
                      '¡Orden creada con exito!',
                      textAlign: TextAlign.center,
                    ),
                    TextNormal(
                      'Se creo la orden correctamente',
                      textAlign: TextAlign.center,
                    ),
                    SpaceY(
                      percent: 2,
                    ),
                    Image(height: 250, image: AssetImage('assets/icons/6.png')),
                    SpaceY(
                      percent: 2,
                    ),
                    TextLead(
                      '${orderService.ordenActual.cliente}',
                      textAlign: TextAlign.center,
                    ),
                    SpaceY(
                      percent: .5,
                    ),
                    TextNormal(
                      '${orderService.ordenActual.switchEnvio == true ? 'Envio a ${orderService.ordenActual.ubicacionLocal}' : '${orderService.ordenActual.ubicacionLocal}'}',
                      textAlign: TextAlign.center,
                    ),
                    SpaceY(),
                    TextTitle(
                      'Total \$${orderService.ordenActual.totalPrecio}',
                      textAlign: TextAlign.center,
                    ),
                    SpaceY(
                      percent: .5,
                    ),
                    TextSmall(
                      '${orderService.ordenActual.fecha!.hour.toString().padLeft(2, '0')}:${orderService.ordenActual.fecha!.minute.toString().padLeft(2, '0')} ${orderService.ordenActual.fecha!.hour < 12 ? 'AM' : 'PM'}  ${orderService.ordenActual.fecha!.day.toString().padLeft(2, '0')}-${orderService.ordenActual.fecha!.month.toString().padLeft(2, '0')}-${orderService.ordenActual.fecha!.year.toString().padLeft(2, '0')}',
                      textAlign: TextAlign.center,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                        onPressed:
                            printerService.switchConectandoPrinter == false
                                ? () {
                                    paymentSuccessProvider
                                        .imprimirTicketComanda(context);
                                  }
                                : null,
                        child: printerService.switchConectandoPrinter == false
                            ? TextNormal(
                                'Imprimir ticket y comanda',
                                fontWeight: FontWeight.bold,
                              )
                            : CircularProgressIndicator()),
                    TextButton(
                        onPressed: () {
                          paymentSuccessProvider.cerrarExito(context);
                        },
                        child: TextNormal(
                          'Salir sin imprimir',
                          fontWeight: FontWeight.bold,
                        ))
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

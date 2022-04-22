import 'package:allegro_saludable/services/order/order_service.dart';
import 'package:allegro_saludable/services/printer/printer_service.dart';
import 'package:allegro_saludable/views/payment/payment_provider.dart';
import 'package:allegro_saludable/views/payment/subpages/caja/payment_caja_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentSuccessProvider extends ChangeNotifier {
  imprimirTicketComanda(BuildContext context) async {
    final printerService = Provider.of<PrinterService>(context, listen: false);
    final orderService = Provider.of<OrderService>(context, listen: false);
    await printerService.imprimir(context,
        opcion: 0, orderModel: orderService.ordenActual, cerrar: true);
  }

  imprimirTicket(BuildContext context) async {
    final printerService = Provider.of<PrinterService>(context, listen: false);
    final orderService = Provider.of<OrderService>(context, listen: false);
    await printerService.imprimir(context,
        opcion: 1, orderModel: orderService.ordenActual, cerrar: true);
  }

  imprimirComanda(BuildContext context) async {
    final printerService = Provider.of<PrinterService>(context, listen: false);
    final orderService = Provider.of<OrderService>(context, listen: false);
    await printerService.imprimir(context,
        opcion: 2, orderModel: orderService.ordenActual, cerrar: true);
  }

  cerrarExito(BuildContext context) async {
    final orderService = Provider.of<OrderService>(context, listen: false);
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);
    final paymentCajaProvider =
        Provider.of<PaymentCajaProvider>(context, listen: false);

    Navigator.pushNamedAndRemoveUntil(context, '/tabs', (route) => false);
    await Future.delayed(const Duration(milliseconds: 500), () {});

    orderService.resetearModelo(context);

    notifyListeners();
  }
}

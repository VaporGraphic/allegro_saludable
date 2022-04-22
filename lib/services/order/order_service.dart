import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';

import 'package:allegro_saludable/models/models.dart';
import 'package:provider/provider.dart';

class OrderService extends ChangeNotifier {
  OrderModel ordenActual = OrderModel(
      cliente: '',
      estadoPedido: 'Preparando',
      switchEnvio: false,
      ubicacion: '',
      ubicacionLocal: '',
      numero: null,
      switchTarjeta: false,
      referenciaTarjeta: '',
      fecha: null,
      itemsList: [],
      subtotalPrecio: 0,
      envioPrecio: 0,
      totalPrecio: 0,
      efectivoRecibido: 0,
      cambioEntregado: 0);

  //LISADO DE PRODUCTOS

  agregarItem(ItemCartModel item) {
    ordenActual.itemsList!.add(item);
    actualizarPrecio();
    notifyListeners();
  }

  actualizarItem(ItemCartModel item, int index) {
    ordenActual.itemsList![index] = item;
    actualizarPrecio();
    notifyListeners();
  }

  eliminarItem(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Eliminar'),
            content: Text('¿Deseas eliminar el producto de tu carrito?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ordenActual.itemsList!.removeAt(index);
                    actualizarPrecio();

                    notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Text('Eliminar')),
            ],
          );
        });
  }

  //ELIMINAR CARRITO

  borrarCarrito(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Limpiar'),
            content: Text('¿Desear limpiar todos los productos seleccionados?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ordenActual.itemsList = [];
                    actualizarPrecio();

                    notifyListeners();
                  },
                  child: Text('Limpiar')),
            ],
          );
        });
  }

  //NAVEGAR A PAGO

  abrirPago(BuildContext context) {
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    paymentProvider.establecerForm(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentView()),
    );
  }

  //ACTUALIZAR PRECIO TOTAL

  actualizarPrecio() {
    //ACTUALIZAR SUBTOTAL
    ordenActual.subtotalPrecio = 0;
    for (var producto in ordenActual.itemsList!) {
      ordenActual.subtotalPrecio =
          ordenActual.subtotalPrecio! + producto.totalPrecio!;
    }

    ordenActual.totalPrecio = 0;
    if (ordenActual.switchEnvio == true) {
      ordenActual.totalPrecio =
          ordenActual.subtotalPrecio! + ordenActual.envioPrecio!;
    } else {
      ordenActual.totalPrecio = ordenActual.subtotalPrecio!;
    }

    notifyListeners();
  }

  toogleEnvio(bool value) {
    ordenActual.switchEnvio = value;
    actualizarPrecio();
    notifyListeners();
  }

  toogleTarjeta(bool value) {
    ordenActual.switchTarjeta = value;
    actualizarPrecio();
    notifyListeners();
  }

  resetearModelo(BuildContext context) {
    ordenActual = OrderModel(
        cliente: '',
        estadoPedido: 'Preparando',
        switchEnvio: false,
        ubicacion: '',
        ubicacionLocal: '',
        numero: null,
        switchTarjeta: false,
        referenciaTarjeta: '',
        fecha: null,
        itemsList: [],
        subtotalPrecio: 0,
        envioPrecio: 0,
        totalPrecio: 0,
        efectivoRecibido: 0,
        cambioEntregado: 0);

    notifyListeners();
  }
}

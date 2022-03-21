import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/cart/widgets/product_tile.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/widgets/appbar/appbar_widget.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderService = Provider.of<OrderService>(context);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Carrito',
        actions: [
          TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.all(15)),
              onPressed: () {
                orderService.borrarCarrito(context);
              },
              child: Center(
                  child: TextNormal(
                'Limpiar',
                fontWeight: FontWeight.bold,
              )))
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
                child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextTitle('Lista de productos'),
                        Text(
                            'Cantidad seleccionada (${orderService.ordenActual.itemsList!.length})'),
                      ],
                    )),
                for (var i = 0;
                    i < orderService.ordenActual.itemsList!.length;
                    i++)
                  ProducTile(
                    itemCart: orderService.ordenActual.itemsList![i],
                    index: i,
                  ),
                //Text(orderService.ordenActual.toMap().toString())
              ],
            )),
            Container(
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                  onPressed: orderService.ordenActual.itemsList!.length > 0
                      ? () {
                          orderService.abrirPago(context);
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextNormal(
                        'Pagar \$${orderService.ordenActual.subtotalPrecio}',
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

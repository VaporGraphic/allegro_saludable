import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProducTile extends StatelessWidget {
  final ItemCartModel itemCart;
  final int index;

  const ProducTile({
    Key? key,
    required this.itemCart,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          final productSelectorProvider =
              Provider.of<ProductSelectorProvider>(context, listen: false);

          productSelectorProvider.editarModelo(
              ItemCartModel.fromMap(itemCart.toMap()), index);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProductSelectorView()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.15),
                            blurRadius: 1.0,
                            spreadRadius: .25,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Colors.grey.withOpacity(.25))),
                    padding: EdgeInsets.all(15),
                    width: 75,
                    height: 75,
                    child: Image(
                        image:
                            AssetImage('assets/icons/${itemCart.icono}.png')),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.5),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.15),
                              blurRadius: 1.0,
                              spreadRadius: .25,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey.withOpacity(.25))),
                      child: TextNormal(
                        '${itemCart.cantidad}',
                      ),
                    ),
                  )
                ],
              ),
              SpaceX(),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextNormal(
                    '${itemCart.nombre}',
                    maxLines: 2,
                    fontWeight: FontWeight.bold,
                  ),
                  TextNormal(
                    '${itemCart.modeloSeleccionado!.subnombre}',
                    color: Colors.grey,
                  )
                ],
              )),
              SpaceX(),
              TextNormal(
                '\$${itemCart.totalPrecio}',
                fontWeight: FontWeight.bold,
              )
            ],
          ),
        ),
      ),
    );
  }
}

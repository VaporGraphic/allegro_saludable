import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSelectorView extends StatelessWidget {
  const ProductSelectorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productSelectorProvider =
        Provider.of<ProductSelectorProvider>(context);

    final orderService = Provider.of<OrderService>(context);

    List<Widget> listComplementos(
        List<ComplementosSeleccionados> complementos) {
      List<Widget> editoresComplementos = [
        SpaceY(),
        TextLead(
          'Complementos:',
          fontWeight: FontWeight.bold,
        ),
        Divider(),
        for (var i = 0; i < complementos.length; i++)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextNormal(
                        '${complementos[i].complementoData.nombre}',
                        maxLines: 2,
                      ),
                      TextSmall(
                        'Gratis',
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  )),
                  Checkbox(
                      fillColor: MaterialStateProperty.all<Color>(
                          Colors.deepPurpleAccent),
                      value: complementos[i].seleccionado,
                      onChanged: (value) {
                        productSelectorProvider.seleccionarComplemento(
                            value!, i);
                      })
                ],
              ),
              Divider()
            ],
          )
      ];
      return editoresComplementos;
    }

    listExtras(List<ExtrasSeleccionados> extras) {
      List<Widget> editoresExtras = [
        SpaceY(),
        TextLead(
          'Extras:',
          fontWeight: FontWeight.bold,
        ),
        Divider(),
        for (var i = 0; i < extras.length; i++)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextNormal(
                        '(\$${extras[i].extraData.precio}) ${extras[i].extraData.nombre}',
                        maxLines: 2,
                      ),
                      TextSmall(
                        '+\$${extras[i].subtotal}',
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  )),
                  Row(
                    children: [
                      extras[i].cantidad > 0
                          ? IconButton(
                              onPressed: () {
                                productSelectorProvider.restarExtra(i);
                              },
                              icon: Icon(
                                Icons.remove_rounded,
                                color: Colors.deepPurpleAccent,
                              ))
                          : Container(),
                      extras[i].cantidad > 0
                          ? Container(
                              width: 35,
                              child: Center(
                                  child: TextLead('${extras[i].cantidad}')),
                            )
                          : Container(),
                      IconButton(
                          color: Colors.deepPurpleAccent,
                          onPressed: () {
                            productSelectorProvider.sumarExtra(i);
                          },
                          icon: Icon(
                            Icons.add_rounded,
                          )),
                    ],
                  )
                ],
              ),
              Divider()
            ],
          )
      ];
      return editoresExtras;
    }

    ListResumen() {
      List<Widget> listResumen = [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextLead(
              'Resumen producto:',
            ),
            IconButton(
                onPressed: () {
                  productSelectorProvider.toggleResumen();
                },
                icon: Icon(Icons.close_rounded))
          ],
        ),
        Divider(),
        SpaceY(
          percent: .5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextNormal(
              'Producto:',
              color: Colors.grey,
            ),
            TextNormal(
              '\$${productSelectorProvider.itemCartModel.modeloSeleccionado!.precio}',
            )
          ],
        ),
        SpaceY(
          percent: .25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextNormal(
              'Extras:',
              color: Colors.grey,
            ),
            TextNormal(
              '+\$${productSelectorProvider.itemCartModel.extrasPrecio}',
            )
          ],
        ),
        SpaceY(
          percent: .25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextNormal(
              'Subtotal por unidad:',
              color: Colors.grey,
            ),
            TextNormal(
              '\$${productSelectorProvider.itemCartModel.subTotalPrecio}',
            )
          ],
        ),
        SpaceY(
          percent: .5,
        ),
        Divider(),
        SpaceY(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextNormal(
              'Total (${productSelectorProvider.itemCartModel.cantidad} productos):',
            ),
            TextLead(
              '\$${productSelectorProvider.itemCartModel.totalPrecio}',
            )
          ],
        ),
        SpaceY()
      ];
      return listResumen;
    }

    return WillPopScope(
      onWillPop: () async {
        productSelectorProvider.backButton(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBarWidget(
          leading: IconButton(
              onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
          title: 'Seleccionar',
          actions: [
            productSelectorProvider.indexEditable != null
                ? TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.all(10)),
                    onPressed: () {
                      orderService.eliminarItem(
                          context, productSelectorProvider.indexEditable!);
                    },
                    child: TextNormal(
                      'Eliminar',
                      fontWeight: FontWeight.bold,
                    ))
                : Container()
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
                    padding: EdgeInsets.all(15),
                    children: [
                      TextTitle(
                        productSelectorProvider.itemCartModel.nombre!,
                        maxLines: 3,
                      ),
                      Text(
                        productSelectorProvider
                            .itemCartModel.modeloSeleccionado!.subnombre,
                      ),
                      Image(
                        image: AssetImage(
                            'assets/icons/${productSelectorProvider.itemCartModel.icono}.png'),
                        height: 150,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextSmall('Precio unidad:',
                                    fontWeight: FontWeight.w100),
                                TextTitle(
                                  '\$${productSelectorProvider.itemCartModel.modeloSeleccionado!.precio}',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (productSelectorProvider
                          .itemCartModel.listComplementos!.isNotEmpty)
                        ...listComplementos(productSelectorProvider
                            .itemCartModel.listComplementos!),
                      if (productSelectorProvider
                          .itemCartModel.listExtras!.isNotEmpty)
                        ...listExtras(
                            productSelectorProvider.itemCartModel.listExtras!),
                      SpaceY(),
                      TextLead(
                        'Comentarios:',
                        fontWeight: FontWeight.bold,
                      ),
                      SpaceY(),
                      TextField(
                        controller:
                            productSelectorProvider.comentariosController,
                        onChanged: (value) {
                          productSelectorProvider.editarComentario(value);
                        },
                        maxLines: 3,
                        decoration: InputDecoration(
                            filled: true, hintText: 'Nota extra para producto'),
                      ),
                      SpaceY(),

                      //Text('${productSelectorProvider.itemCartModel.toJson()}')
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: paymentStack(context, productSelectorProvider,
                      orderService, ListResumen),
                )
              ],
            )),
      ),
    );
  }

  Widget paymentStack(
      BuildContext context,
      ProductSelectorProvider productSelectorProvider,
      OrderService orderService,
      List<Widget> ListResumen()) {
    return Container(
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSize(
                duration: Duration(milliseconds: 150),
                curve: Curves.fastOutSlowIn,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 100),
                  child: productSelectorProvider.switchResumen == true
                      ? Column(
                          key: Key("loading"),
                          children: [...ListResumen()],
                        )
                      : Container(
                          key: Key("normal"),
                        ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          productSelectorProvider.restarProducto();
                        },
                        icon: Icon(Icons.remove_rounded),
                        color: Colors.deepPurpleAccent,
                      ),
                      Expanded(
                          child: TextLead(
                        '${productSelectorProvider.itemCartModel.cantidad!}',
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.bold,
                      )),
                      IconButton(
                          onPressed: () {
                            print('asd');
                            productSelectorProvider.sumarProducto();
                          },
                          /*
                              productSelectorProvider.itemCartModel.cantidad! <
                                      productSelectorProvider.itemCartModel
                                          .modeloSeleccionado!.stock
                                  ? () {
                                      productSelectorProvider.sumarProducto();
                                    }
                                  : null, */
                          icon: Icon(Icons.add_rounded,
                              color: Colors.deepPurpleAccent
                              /* productSelectorProvider
                                        .itemCartModel.cantidad! <
                                    productSelectorProvider
                                        .itemCartModel.modeloSeleccionado!.stock
                                ? Colors.deepPurpleAccent
                                : Colors.grey,*/
                              )),
                    ],
                  )),
                  SpaceX(
                    percent: .5,
                  ),
                  Expanded(
                    child: productSelectorProvider.switchResumen == false
                        ? ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.black),
                            onPressed: () {
                              productSelectorProvider.toggleResumen();
                            },
                            child: TextNormal(
                              'Total \$${productSelectorProvider.itemCartModel.totalPrecio}',
                              fontWeight: FontWeight.bold,
                            ))
                        : ElevatedButton(
                            onPressed: () {
                              if (productSelectorProvider.indexEditable !=
                                  null) {
                                orderService.actualizarItem(
                                    productSelectorProvider.itemCartModel,
                                    productSelectorProvider.indexEditable!);
                              } else {
                                orderService.agregarItem(
                                    productSelectorProvider.itemCartModel);
                              }

                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_bag_outlined),
                                SpaceX(
                                  percent: .5,
                                ),
                                TextNormal(
                                  productSelectorProvider.indexEditable != null
                                      ? 'Actualizar'
                                      : 'Agregar',
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

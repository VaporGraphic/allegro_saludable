import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdenesEditorView extends StatelessWidget {
  const OrdenesEditorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordenesEditorProvider = Provider.of<OrdenesEditorProvider>(context);

    return Scaffold(
      floatingActionButton:
          ordenesEditorProvider.ordenEditar!.estadoPedido != 'cancelado'
              ? FloatingActionButton(
                  onPressed: () {
                    ordenesEditorProvider.opcionesImprimir(context);
                  },
                  child: Icon(Icons.print_outlined),
                )
              : Container(),
      appBar: AppBarWidget(
        title: ordenesEditorProvider.ordenEditar!.estadoPedido == 'cancelado'
            ? 'Orden cancelada'
            : 'Datos orden',
        actions: [
          if (ordenesEditorProvider.ordenEditar!.estadoPedido != 'cancelado')
            IconButton(
                onPressed: () {
                  ordenesEditorProvider.mostrarOpciones(context);
                },
                icon: Icon(Icons.more_vert_outlined))
        ],
      ),
      body: Opacity(
        opacity: ordenesEditorProvider.ordenEditar!.estadoPedido == 'cancelado'
            ? .5
            : 1,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ordenesEditorProvider.ordenEditar!.estadoPedido ==
                      'cancelado')
                    TextSmall(
                      'Orden cancelada',
                    ),
                  TextTitle(
                    'Cliente: ${ordenesEditorProvider.ordenEditar!.cliente}',
                    maxLines: 3,
                  ),
                  Text(
                      '${ordenesEditorProvider.ordenEditar!.fecha!.hour.toString().padRight(2, '0')}:${ordenesEditorProvider.ordenEditar!.fecha!.minute.toString().padRight(2, '0')}  ${ordenesEditorProvider.ordenEditar!.fecha!.day}/${ordenesEditorProvider.ordenEditar!.fecha!.month}/${ordenesEditorProvider.ordenEditar!.fecha!.year}'),
                  SpaceY(),
                  ordenesEditorProvider.ordenEditar!.switchEnvio == true
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.pedal_bike_outlined,
                              color: Colors.black.withOpacity(.75),
                            ),
                            SpaceX(
                              percent: .25,
                            ),
                            TextNormal(
                                'Envio: ${ordenesEditorProvider.ordenEditar!.ubicacion}'),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.storefront_outlined,
                              color: Colors.black.withOpacity(.75),
                            ),
                            SpaceX(
                              percent: .25,
                            ),
                            TextNormal(
                                'Local: ${ordenesEditorProvider.ordenEditar!.ubicacionLocal}'),
                          ],
                        ),
                  SpaceY(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall('Productos seleccionados (1)'),
                      TextNormal(
                        'Total: \$${ordenesEditorProvider.ordenEditar!.totalPrecio}',
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            for (var itemCart in ordenesEditorProvider.ordenEditar!.itemsList!)
              ProductTile(modelo: ItemCartModel.fromMap(itemCart.toMap())),
            SpaceY(
              percent: 5,
            )
          ],
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final ItemCartModel modelo;

  const ProductTile({
    Key? key,
    required this.modelo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: null,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        image: AssetImage('assets/icons/${modelo.icono}.png')),
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
                        '${modelo.cantidad}',
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
                    '${modelo.nombre}',
                    maxLines: 2,
                    fontWeight: FontWeight.bold,
                  ),
                  TextNormal(
                    '${modelo.modeloSeleccionado!.subnombre}',
                    color: Colors.grey.shade700,
                  ),
                  for (var complemento in modelo.listComplementos!)
                    if (complemento.seleccionado == true)
                      TextSmall(
                        ' -${complemento.complementoData.nombre}',
                        color: Colors.grey,
                      ),
                  for (var extra in modelo.listExtras!)
                    if (extra.cantidad > 0)
                      TextSmall(
                        ' -${extra.extraData.nombre} - \$${extra.extraData.precio}',
                        color: Colors.grey,
                      ),
                  if (modelo.notaExtra!.isNotEmpty)
                    TextSmall(
                      'Comentario: ${modelo.notaExtra}',
                      color: Colors.deepPurpleAccent,
                      maxLines: 10,
                    ),
                ],
              )),
              SpaceX(),
              TextNormal(
                '\$${modelo.totalPrecio}',
                fontWeight: FontWeight.bold,
              )
            ],
          ),
        ),
      ),
    );
  }
}

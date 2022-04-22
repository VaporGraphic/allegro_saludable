import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/firebase/inventario/inventario_crud_service.dart';
import 'package:allegro_saludable/views/ajustes/subpages/inventario/widgets/product_tile.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AjustesInventarioView extends StatelessWidget {
  const AjustesInventarioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ajustesInventarioProvider =
        Provider.of<AjustesInventarioProvider>(context);

    final inventarioCrudService = Provider.of<InventarioCrudService>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            ajustesInventarioProvider.abrirEditor(context);
          },
          child: Icon(Icons.add_rounded)),
      appBar: AppBarWidget(
        title: 'Ajustes Inventario',
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        physics: BouncingScrollPhysics(),
        children: [
          TextTitle('Ajustes Inventario'),
          TextNormal('Administra tu inventario'),
          SpaceY(),
          TextField(
            controller: ajustesInventarioProvider.busquedaController,
            onChanged: (value) {
              ajustesInventarioProvider
                  .filtrarBusqueda(inventarioCrudService.listInventario);
            },
            decoration: InputDecoration(
                filled: true,
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar en inventario'),
          ),
          SpaceY(),
          ajustesInventarioProvider.switchBusqueda == true
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextNormal(
                    'Resultados busqueda ${ajustesInventarioProvider.listaFiltrada.length}:',
                    color: Colors.grey,
                  ),
                )
              : Container(),
          if (ajustesInventarioProvider.switchBusqueda == false)
            for (var i = 0;
                i < inventarioCrudService.listInventario.length;
                i++)
              ProductTile(
                  index: i,
                  modelo: ProductoModel.fromMap(
                    inventarioCrudService.listInventario[i].toMap(),
                  ))
          else
            for (var i = 0;
                i < ajustesInventarioProvider.listaFiltrada.length;
                i++)
              ProductTile(
                  index: i,
                  modelo: ProductoModel.fromMap(
                    ajustesInventarioProvider.listaFiltrada[i].toMap(),
                  ))
        ],
      ),
    );
  }
}

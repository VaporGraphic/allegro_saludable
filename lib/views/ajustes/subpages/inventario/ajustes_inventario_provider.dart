import 'dart:async';

import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/firebase/inventario/inventario_crud_service.dart';
import 'package:allegro_saludable/views/editor/inventario/editor_inventario_provider.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AjustesInventarioProvider extends ChangeNotifier {
  //BUSQUEDA CONTROLLERS
  TextEditingController busquedaController = TextEditingController();
  bool switchBusqueda = false;
  List<ProductoModel> listaFiltrada = [];

  filtrarBusqueda(List<ProductoModel> listaOriginal) {
    listaFiltrada = [];
    switchBusqueda = false;

    EasyDebounce.debounce(
        'buscar-ajustes-debouncer', Duration(milliseconds: 500), () {
      print('Buscando filtro');
      if (busquedaController.text.isNotEmpty) {
        switchBusqueda = true;

        print('La busqueda muestra algo');

        for (var producto in listaOriginal) {
          print(
              'comprobando ${producto.nombre} vs ${busquedaController.text} ${producto.nombre.toLowerCase().contains(busquedaController.text.toLowerCase())}');

          if (producto.nombre
                  .toLowerCase()
                  .contains(busquedaController.text.toLowerCase()) ==
              true) {
            listaFiltrada.add(producto);
          }
        }
      }
      print(
          '${listaFiltrada.toString()}, lista vacia ${listaFiltrada.isEmpty}');
      notifyListeners();
    });
  }

  abrirEditor(BuildContext context, {ProductoModel? modelo}) {
    final editorInventarioProvider =
        Provider.of<EditorInventarioProvider>(context, listen: false);

    if (modelo != null) {
      editorInventarioProvider.setProducto(modelo);
    } else {
      editorInventarioProvider.resetProducto();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditorInventarioView()),
    );
  }

  showModalOpciones(BuildContext context, ProductoModel model, int index) {
    final inventarioCrudService =
        Provider.of<InventarioCrudService>(context, listen: false);

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: TextLead(model.nombre)),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close))
                  ],
                ),
                Divider(),
                TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.all(15)),
                    onPressed: () {
                      Navigator.pop(context);
                      abrirEditor(context,
                          modelo: ProductoModel.fromMap(model.toMap()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.edit_outlined),
                        SpaceX(),
                        Text('Editar producto'),
                      ],
                    )),
                TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.all(15)),
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Eliminar'),
                              content: Text(
                                  '¿Deseas eliminar el producto "${model.nombre}" para siempre?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancelar')),
                                ElevatedButton(
                                    onPressed: () {
                                      inventarioCrudService.eliminarProducto(
                                          context, model);
                                    },
                                    child: Text('Eliminar')),
                              ],
                            );
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.delete_outline),
                        SpaceX(),
                        Text('Eliminar'),
                      ],
                    )),
              ],
            ),
          );
        });
  }
}

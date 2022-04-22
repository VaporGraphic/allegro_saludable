import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/editor/inventario/widgets/modal_button.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditorInventarioComplementosProvider extends ChangeNotifier {
  abirEditor(BuildContext context, {ComplementosModel? modelo, int? index}) {
    final editorInventarioProvider = context.read<EditorInventarioProvider>();

    final okToastService = Provider.of<OkToastService>(context, listen: false);

    TextEditingController nombreController = TextEditingController();

    ComplementosModel complementoEditable = ComplementosModel(
        imprimirSeparado: false,
        nombre: '',
        categoria: CategoriaModel(nombre: ''));

    if (modelo != null) {
      complementoEditable = modelo;
      nombreController.text = modelo.nombre;
    }

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(7.5),
              title: Row(
                children: [
                  Expanded(
                      child: Text(index == null
                          ? 'Crear complemento'
                          : 'Editar complemento')),
                  index != null
                      ? IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Eliminar'),
                                    content: Text(
                                        '¿Deseas eliminar el complemento?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Cancelar')),
                                      ElevatedButton(
                                          onPressed: () {
                                            editorInventarioProvider
                                                .productoEditable
                                                .listComplementos
                                                .removeAt(index);

                                            notifyListeners();
                                            Navigator.pop(context);
                                          },
                                          child: Text('Eliminar')),
                                    ],
                                  );
                                });
                          },
                          icon: Icon(Icons.delete_outline))
                      : Container()
                ],
              ),
              content: Container(
                width: 800,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                        title: Text('Imprimir por separado'),
                        value: complementoEditable.imprimirSeparado,
                        onChanged: (value) {
                          setState(() {
                            complementoEditable.imprimirSeparado = value;
                          });
                        }),
                    SpaceY(),
                    TextField(
                      controller: nombreController,
                      onChanged: (value) {
                        setState(() {
                          complementoEditable.nombre = value;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.edit),
                          hintText: 'Nombre del complemento'),
                    ),
                    SpaceY(),
                    ModalButton(
                        selectedTitle: complementoEditable.categoria.nombre,
                        selected:
                            complementoEditable.categoria.nombre.isNotEmpty,
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                        children: [
                                          SpaceY(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextLead('Tipo de unidad'),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    onTap: () =>
                                                        Navigator.pop(context),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(7.5),
                                                      child: Icon(Icons.close),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          Divider(),
                                          Expanded(
                                              child: ListView(
                                            physics: BouncingScrollPhysics(),
                                            children: [
                                              for (var categoria
                                                  in editorInventarioProvider
                                                      .ListCategorias)
                                                TextButton(
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.all(15)),
                                                    onPressed: () {
                                                      setState(() {
                                                        complementoEditable
                                                                .categoria =
                                                            categoria;
                                                        print('set state');
                                                      });

                                                      Navigator.pop(context);
                                                    },
                                                    child: TextNormal(
                                                      categoria.nombre,
                                                      fontWeight:
                                                          complementoEditable
                                                                      .categoria !=
                                                                  categoria
                                                              ? FontWeight
                                                                  .normal
                                                              : FontWeight.bold,
                                                    )),
                                              SpaceY(
                                                percent: 4,
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        title: 'Categoria',
                        icon: Icons.sell_outlined),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar')),
                index == null
                    ? ElevatedButton(
                        onPressed: () {
                          if (nombreController.text.isNotEmpty &&
                              complementoEditable.categoria.nombre.isNotEmpty) {
                            editorInventarioProvider
                                .productoEditable.listComplementos
                                .add(complementoEditable);
                            Navigator.pop(context);
                          } else {
                            okToastService.showOkToast(
                                mensaje: 'Por favor llenar todos los campos');
                          }

                          notifyListeners();
                        },
                        child: Text('Crear complemento'))
                    : ElevatedButton(
                        onPressed: () {
                          if (nombreController.text.isNotEmpty &&
                              complementoEditable.categoria.nombre.isNotEmpty) {
                            editorInventarioProvider.productoEditable
                                .listComplementos[index] = complementoEditable;
                            notifyListeners();
                            Navigator.pop(context);
                          } else {
                            okToastService.showOkToast(
                                mensaje: 'Por favor llenar todos los campos');
                          }
                        },
                        child: Text('Guardar cambios'))
              ],
            );
          });
        });
  }

  showModalUnidadEditor(BuildContext context) {}
}

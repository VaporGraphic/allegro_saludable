import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/editor/inventario/widgets/modal_button.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditorInventarioExtrasProvider extends ChangeNotifier {
  abirEditor(BuildContext context, {ExtrasModel? modelo, int? index}) {
    final editorInventarioProvider = context.read<EditorInventarioProvider>();

    final okToastService = Provider.of<OkToastService>(context, listen: false);

    TextEditingController nombreController = TextEditingController();
    TextEditingController precioController = TextEditingController();

    ExtrasModel extraEditable = ExtrasModel(
        imprimirSeparado: false,
        nombre: '',
        precio: 0,
        categoria: CategoriaModel(nombre: ''));

    if (modelo != null) {
      extraEditable = modelo;
      nombreController.text = modelo.nombre;
      precioController.text = modelo.precio.toString();
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
                      child:
                          Text(index == null ? 'Crear extra' : 'Editar extra')),
                  index != null
                      ? IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Eliminar'),
                                    content: Text('¿Deseas eliminar el extra?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Cancelar')),
                                      ElevatedButton(
                                          onPressed: () {
                                            editorInventarioProvider
                                                .productoEditable.listExtras
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
                        value: extraEditable.imprimirSeparado,
                        onChanged: (value) {
                          setState(() {
                            extraEditable.imprimirSeparado = value;
                          });
                        }),
                    SpaceY(),
                    TextField(
                      controller: nombreController,
                      onChanged: (value) {
                        setState(() {
                          extraEditable.nombre = value;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.edit),
                          hintText: 'Nombre del extra'),
                    ),
                    SpaceY(),
                    TextField(
                      controller: precioController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            extraEditable.precio = double.parse(value);
                          });
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'))
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.payments_outlined),
                          hintText: 'Precio del extra'),
                    ),
                    SpaceY(),
                    ModalButton(
                        selectedTitle: extraEditable.categoria.nombre,
                        selected: extraEditable.categoria.nombre.isNotEmpty,
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
                                                        extraEditable
                                                                .categoria =
                                                            categoria;
                                                        print('set state');
                                                      });

                                                      Navigator.pop(context);
                                                    },
                                                    child: TextNormal(
                                                      categoria.nombre,
                                                      fontWeight: extraEditable
                                                                  .categoria !=
                                                              categoria
                                                          ? FontWeight.normal
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
                              precioController.text.isNotEmpty &&
                              extraEditable.categoria.nombre.isNotEmpty) {
                            editorInventarioProvider.productoEditable.listExtras
                                .add(extraEditable);
                            notifyListeners();
                            Navigator.pop(context);
                          } else {
                            okToastService.showOkToast(
                                mensaje: 'Por favor llenar todos los campos');
                          }
                        },
                        child: Text('Crear extra'))
                    : ElevatedButton(
                        onPressed: () {
                          if (nombreController.text.isNotEmpty &&
                              precioController.text.isNotEmpty &&
                              extraEditable.categoria.nombre.isNotEmpty) {
                            editorInventarioProvider.productoEditable
                                .listExtras[index] = extraEditable;
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

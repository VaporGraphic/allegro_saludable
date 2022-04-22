import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/oktoast/oktoast_service.dart';
import 'package:allegro_saludable/views/editor/inventario/editor_inventario_provider.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditorInventarioVariacionesProvider extends ChangeNotifier {
  abrirGenerador(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const EditorInventarioVariacionesEditView()),
    );
  }

  //GENERADOR

  abrirEditorGenerador(BuildContext context,
      {GeneradorModel? modelo, int? index}) {
    final okToastService = Provider.of<OkToastService>(context, listen: false);
    final editorInventarioProvider =
        Provider.of<EditorInventarioProvider>(context, listen: false);

    GeneradorModel generadorEditable =
        GeneradorModel(titulo: '', listModelos: []);

    TextEditingController nombreController = TextEditingController();
    TextEditingController generadorController = TextEditingController();

    if (index != null) {
      generadorEditable = modelo!;
      nombreController.text = modelo.titulo;
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
                      child: Text(index != null
                          ? 'Editar generador'
                          : 'Crear generador')),
                  index != null
                      ? IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Eliminar'),
                                    content:
                                        Text('¿Deseas eliminar generador?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Cancelar')),
                                      ElevatedButton(
                                          onPressed: () {
                                            editorInventarioProvider
                                                .productoEditable
                                                .listGeneradores
                                                .removeAt(index);
                                            Navigator.pop(context);
                                            notifyListeners();
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
                height: 500,
                child: Column(
                  children: [
                    Expanded(
                        child: Material(
                      color: Colors.transparent,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          TextField(
                            onChanged: (value) {
                              generadorEditable.titulo = value;
                            },
                            controller: nombreController,
                            decoration: InputDecoration(
                                hintText: 'Nombre del generador',
                                prefixIcon: Icon(Icons.edit)),
                          ),
                          SpaceY(),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: generadorController,
                                  decoration: InputDecoration(
                                      hintText: 'Escribir variacion',
                                      prefixIcon:
                                          Icon(Icons.view_agenda_outlined)),
                                ),
                              ),
                              SpaceX(),
                              ElevatedButton(
                                  onPressed: () {
                                    if (generadorController.text.isEmpty) {
                                      okToastService.showOkToast(
                                          mensaje:
                                              'Escribe el nombre de la variacion');
                                    } else {
                                      setState(() {
                                        generadorEditable.listModelos
                                            .add(generadorController.text);
                                        generadorController.clear();
                                      });
                                    }
                                  },
                                  child: Text('Agregar'))
                            ],
                          ),
                          SpaceY(),
                          for (var i = 0;
                              i < generadorEditable.listModelos.length;
                              i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: ListTile(
                                title: Text(generadorEditable.listModelos[i]),
                                trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        generadorEditable.listModelos
                                            .removeAt(i);
                                      });
                                    },
                                    icon: Icon(Icons.delete_outline)),
                              ),
                            )
                        ],
                      ),
                    ))
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
                              generadorEditable.listModelos.isNotEmpty) {
                            editorInventarioProvider
                                .productoEditable.listGeneradores
                                .add(generadorEditable);
                            Navigator.pop(context);
                          } else if (nombreController.text.isEmpty) {
                            okToastService.showOkToast(
                                mensaje: 'Escribe un nombre para el generador');
                          } else if (generadorEditable.listModelos.isEmpty) {
                            okToastService.showOkToast(
                                mensaje: 'Agrega minimo una variacion');
                          }
                          notifyListeners();
                        },
                        child: Text('Crear generador'))
                    : ElevatedButton(
                        onPressed: () {
                          if (nombreController.text.isNotEmpty &&
                              generadorEditable.listModelos.isNotEmpty) {
                            editorInventarioProvider.productoEditable
                                .listGeneradores[index] = generadorEditable;
                            Navigator.pop(context);
                          } else if (nombreController.text.isEmpty) {
                            okToastService.showOkToast(
                                mensaje: 'Escribe un nombre para el generador');
                          } else if (generadorEditable.listModelos.isEmpty) {
                            okToastService.showOkToast(
                                mensaje: 'Agrega minimo una variacion');
                          }
                          notifyListeners();
                        },
                        child: Text('Guardar generador'))
              ],
            );
          });
        });
  }

  comprobarVariaciones(BuildContext context) {
    final editorInventarioProvider =
        Provider.of<EditorInventarioProvider>(context, listen: false);

    if (editorInventarioProvider.productoEditable.listVariaciones.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Generar variaciones'),
              content: Text(
                  'Si generas las variaciones se perderan los cambios de las anteriores'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      generarVariaciones(
                          context,
                          editorInventarioProvider
                              .productoEditable.listGeneradores);
                      Navigator.pop(context);
                    },
                    child: Text('Eliminar y generar')),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      generarVariaciones(
          context, editorInventarioProvider.productoEditable.listGeneradores);
    }
  }

  generarVariaciones(
      BuildContext context, List<GeneradorModel> listGeneradores) {
    final editorInventarioProvider =
        Provider.of<EditorInventarioProvider>(context, listen: false);

    List<List<String>> args = [];

    for (var generador in listGeneradores) {
      args.add(generador.listModelos);
    }

    var resultadoList = [], max = args.length - 1;
    helper(arr, i) {
      for (var j = 0, l = args[i].length; j < l; j++) {
        var a = arr.toList(); // clone arr
        a.add(args[i][j]);
        if (i == max)
          resultadoList.add(a);
        else
          helper(a, i + 1);
      }
    }

    helper([], 0);
    print('---------Generando---------');
    editorInventarioProvider.productoEditable.listVariaciones = [];

    for (var resultado in resultadoList) {
      String subnombre = '';

      for (var item in resultado) {
        subnombre += ' $item';
      }

      VariacionModel variacionProvicional =
          VariacionModel(subnombre: subnombre, codigo: '', stock: 0, precio: 0);
      editorInventarioProvider.productoEditable.listVariaciones
          .add(variacionProvicional);
    }
    notifyListeners();
  }

  abrirEditorVariantes(BuildContext context, VariacionModel modelo, int index) {
    final editorInventarioProvider =
        Provider.of<EditorInventarioProvider>(context, listen: false);

    final okToastService = Provider.of<OkToastService>(context, listen: false);

    VariacionModel variacionProvicional = modelo;

    TextEditingController codigoController = TextEditingController();
    codigoController.text = modelo.codigo;
    TextEditingController precioController = TextEditingController();
    precioController.text = modelo.precio.toString();
    TextEditingController stockController = TextEditingController();
    stockController.text = modelo.stock.toString();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                insetPadding: EdgeInsets.all(7.5),
                title: Row(
                  children: [
                    Expanded(child: Text(modelo.subnombre)),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Eliminar variacion'),
                                  content:
                                      Text('¿Deseas eliminar esta variacion?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancelar')),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          editorInventarioProvider
                                              .productoEditable.listVariaciones
                                              .removeAt(index);
                                          notifyListeners();
                                        },
                                        child: Text('Eliminar'))
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.delete_outline))
                  ],
                ),
                content: Container(
                  width: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: codigoController,
                        onChanged: (value) {
                          variacionProvicional.codigo = value;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.view_in_ar),
                            hintText: 'Codigo del producto'),
                      ),
                      SpaceY(),
                      TextField(
                        controller: precioController,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            variacionProvicional.precio = double.parse(value);
                          }
                        },
                        onTap: () {
                          if (precioController.text.isNotEmpty) {
                            if (double.parse(precioController.text) == 0) {
                              precioController.clear();
                            }
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'))
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.payments_outlined),
                            hintText: 'Precio'),
                      ),
                      SpaceY(),
                      editorInventarioProvider.productoEditable.switchStock ==
                              true
                          ? TextField(
                              controller: stockController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'))
                              ],
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  variacionProvicional.stock = int.parse(value);
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.all_inbox_outlined),
                                  hintText: 'Stock'),
                            )
                          : Container(),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar')),
                  ElevatedButton(
                      onPressed: () {
                        if (precioController.text.isNotEmpty &&
                            stockController.text.isNotEmpty) {
                          editorInventarioProvider.productoEditable
                              .listVariaciones[index] = variacionProvicional;
                          Navigator.pop(context);
                        } else {
                          okToastService.showOkToast(
                              mensaje: 'Poner precio y valor de stock');
                        }
                        notifyListeners();
                      },
                      child: Text('Guardar cambios')),
                ],
              );
            },
          );
        });
  }
}

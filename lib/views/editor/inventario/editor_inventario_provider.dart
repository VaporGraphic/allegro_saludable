import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/firebase/inventario/inventario_crud_service.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:allegro_saludable/widgets/spacing/space_widgets.dart';
import 'package:allegro_saludable/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditorInventarioProvider extends ChangeNotifier {
  //EDITABLE
  bool switchEditable = false;

  //LIST UNIDADES
  List<String> ListUnidades = [
    'Pieza',
    'Unidad',
    'Kilo',
    'Gramo',
    'Litro',
    'Mililitro',
    'Metro',
    'Centimetro',
  ];

  List<CategoriaModel> ListCategorias = [
    CategoriaModel(nombre: 'Tienda'),
    CategoriaModel(nombre: 'Cocina caliente'),
    CategoriaModel(nombre: 'Ensaladas/frutas'),
    CategoriaModel(nombre: 'Bebidas'),
  ];

  ProductoModel productoEditable = ProductoModel(
      codigo: '',
      switchStock: true,
      unidad: '',
      icono: '',
      nombre: '',
      switchMultiple: false,
      categoriaModel: CategoriaModel(nombre: ''),
      listGeneradores: [],
      listVariaciones: [],
      listComplementos: [],
      listExtras: []);

  //TEXT CONTORLLERS
  TextEditingController codigoController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  toogleMultiple(bool value) {
    productoEditable.switchMultiple = value;
    notifyListeners();
  }

  toogleStock(bool value) {
    productoEditable.switchStock = value;
    notifyListeners();
  }

  showModalUnidad(BuildContext context) {
    print('asd');
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SpaceY(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextLead('Tipo de unidad'),
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () => Navigator.pop(context),
                              child: Padding(
                                padding: EdgeInsets.all(7.5),
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
                        for (var unidad in ListUnidades)
                          TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(15)),
                              onPressed: () {
                                productoEditable.unidad = unidad;
                                notifyListeners();
                                Navigator.pop(context);
                              },
                              child: TextNormal(
                                unidad,
                                fontWeight: productoEditable.unidad != unidad
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
  }

  showModalCategoria(BuildContext context) {
    print('asd');
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SpaceY(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextLead('Categoria'),
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () => Navigator.pop(context),
                              child: Padding(
                                padding: EdgeInsets.all(7.5),
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
                        for (var categoria in ListCategorias)
                          TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(15)),
                              onPressed: () {
                                productoEditable.categoriaModel = categoria;
                                notifyListeners();
                                Navigator.pop(context);
                              },
                              child: TextNormal(
                                categoria.nombre,
                                fontWeight:
                                    productoEditable.categoriaModel != categoria
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
  }

  abrirExtras(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const EditorInventarioExtrasView()),
    );
  }

  abrirComplementos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const EditorInventarioComplementosView()),
    );
  }

  abrirVariaciones(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const EditorInventarioVariacionesView()),
    );
  }

  seleccionarIcono(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(7.5),
            title: Text('Seleccionar dialogo'),
            content: Container(
              width: 600,
              height: 800,
              child: GridView.count(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                mainAxisSpacing: 7.5,
                crossAxisSpacing: 7.5,
                crossAxisCount: 3,
                children: [
                  for (var i = 0; i < 20; i++)
                    Material(
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            productoEditable.icono = '$i';
                            notifyListeners();
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image(
                              image: AssetImage('assets/icons/$i.png'),
                              height: 25,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'))
            ],
          );
        });
  }

  guardarModelo(BuildContext context) {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    bool errores = false;

    if (productoEditable.icono.isEmpty) {
      okToastService.showOkToast(mensaje: 'Selecciona un icono');
    } else if (productoEditable.unidad.isEmpty) {
      okToastService.showOkToast(mensaje: 'Selecciona un tipo de unidad');
      showModalUnidad(context);
    } else if (productoEditable.categoriaModel.nombre.isEmpty) {
      okToastService.showOkToast(mensaje: 'Selecciona una categoria');
      showModalCategoria(context);
    } else if (productoEditable.switchMultiple == true) {
      if (nombreController.text.isEmpty) {
        okToastService.showOkToast(mensaje: 'Escribir nombre al modelo');
      } else if (productoEditable.listVariaciones.isEmpty) {
        okToastService.showOkToast(
            mensaje: 'Genera por lo menos un modelo de variacion');
        abrirVariaciones(context);
      } else {
        //GENERAR MODELO
        generarModelo(context);
      }
    } else {
      if (nombreController.text.isEmpty) {
        okToastService.showOkToast(mensaje: 'Escribir nombre al modelo');
      } else if (precioController.text.isEmpty) {
        okToastService.showOkToast(mensaje: 'Escribir precio al producto');
      } else if (productoEditable.switchStock == true &&
          stockController.text.isEmpty) {
        okToastService.showOkToast(mensaje: 'Escribir stock o desactivalo');
      } else {
        //GENERAR MODELO
        generarModelo(context);
      }
    }
  }

  generarModelo(BuildContext context) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);
    final inventarioCrudService =
        Provider.of<InventarioCrudService>(context, listen: false);

    if (productoEditable.switchMultiple == true) {
      productoEditable.nombre = nombreController.text;
    } else {
      productoEditable.codigo = codigoController.text;
      productoEditable.nombre = nombreController.text;

      VariacionModel variacionUnica = VariacionModel(
          subnombre: nombreController.text,
          codigo: codigoController.text,
          stock: productoEditable.switchStock == true
              ? int.parse(stockController.text)
              : 0,
          precio: double.parse(precioController.text));
      productoEditable.listVariaciones = [];
      productoEditable.listVariaciones.add(variacionUnica);
    }
    if (switchEditable == true) {
      inventarioCrudService.editarProducto(context, productoEditable);
    } else {
      inventarioCrudService.agregarProducto(context, productoEditable);
    }
    print('OBJETO GENERADO CORRECTAMENTE');
    await Future.delayed(Duration(seconds: 2));

    resetProducto();
  }

  //----------------------------- SET Y RESET -----------------------------

  setProducto(ProductoModel model) {
    switchEditable = true;
    productoEditable = model;

    codigoController.text = model.codigo;
    nombreController.text = model.nombre;
    precioController.text = model.listVariaciones[0].subnombre;
    stockController.text = model.listVariaciones[0].stock.toString();
  }

  resetProducto() {
    switchEditable = false;

    codigoController.clear();
    nombreController.clear();
    precioController.clear();
    stockController.clear();

    productoEditable = ProductoModel(
        codigo: '',
        switchStock: true,
        unidad: '',
        icono: '',
        nombre: '',
        switchMultiple: false,
        categoriaModel: CategoriaModel(nombre: ''),
        listGeneradores: [],
        listVariaciones: [],
        listComplementos: [],
        listExtras: []);
    notifyListeners();
  }

  //-------------------ACTUALIZAR NOTIFIER -------------------

  updateGeneral(BuildContext context) {
    notifyListeners();
    Navigator.pop(context);
  }
}

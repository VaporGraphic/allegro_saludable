import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/firebase/inventario/inventario_crud_service.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_debounce/easy_debounce.dart';

class MenuProvider extends ChangeNotifier {
  //BUSQUEDA CONTROLLER
  TextEditingController busquedaController = TextEditingController();

  bool switchSearch = false;

  CategoriaModel? selectedTag = null;

  List<CategoriaModel> ListCategorias = [
    CategoriaModel(nombre: 'Tienda'),
    CategoriaModel(nombre: 'Cocina caliente'),
    CategoriaModel(nombre: 'Ensaladas/frutas'),
    CategoriaModel(nombre: 'Bebidas'),
  ];

  List<ProductoModel> listProductosFiltrados = [];

  abrirEditor(BuildContext context, ProductoModel modelo,
      VariacionModel variacionSeleccionada) {
    final productSelectorProvider =
        Provider.of<ProductSelectorProvider>(context, listen: false);

    productSelectorProvider.establecerModelo(modelo, variacionSeleccionada);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductSelectorView()),
    );
  }

  busquedaDebounce(BuildContext context) {
    String busqueda = busquedaController.text.toLowerCase();

    if (busqueda.isEmpty) {
      switchSearch = false;
    } else {
      switchSearch = true;
    }

    EasyDebounce.debounce('buscar-debouncer', Duration(milliseconds: 500),
        () => filtarBusqueda(busqueda, context));
  }

  filtarBusqueda(String busqueda, BuildContext context) {
    final inventarioCrudService =
        Provider.of<InventarioCrudService>(context, listen: false);

    listProductosFiltrados = [];
    for (var producto in inventarioCrudService.listInventario) {
      if (producto.nombre.toLowerCase().contains(busqueda)) {
        listProductosFiltrados.add(producto);
      }
    }
    notifyListeners();
  }

  seleccionarTag(CategoriaModel selectedCategoria) {
    selectedTag = selectedCategoria;
    notifyListeners();
  }

  eliminarTag() {
    selectedTag = null;
    notifyListeners();
  }

  seleccionarModeloModal(BuildContext context, ProductoModel producto) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Material(
              color: Colors.transparent,
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(15),
                children: [
                  Row(
                    children: [
                      Expanded(child: TextLead('Seleccionar modelos')),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close))
                    ],
                  ),
                  Divider(),
                  for (var variacion in producto.listVariaciones)
                    TextButton(
                        style:
                            TextButton.styleFrom(padding: EdgeInsets.all(15)),
                        onPressed: () {
                          ProductoModel modeloSeleccionado =
                              ProductoModel.fromMap(producto.toMap());

                          VariacionModel variacionModel =
                              VariacionModel.fromMap(variacion.toMap());
                          Navigator.pop(context);

                          abrirEditor(
                              context, modeloSeleccionado, variacionModel);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(variacion.subnombre)),
                            TextNormal(
                              '\$${variacion.precio}',
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ))
                ],
              ),
            ),
          );
        });
  }
}

import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuProvider extends ChangeNotifier {
  List<ProductoModel> listProductos = [
    ProductoModel(
        icono: '1',
        nombre: 'Hamburguesa con queso chica pequeña',
        switchMultiple: false,
        categoriaModel: CategoriaModel(nombre: 'Categoria'),
        listVariaciones: [
          VariacionModel(subnombre: 'Pollo', codigo: '', stock: 10, precio: 100)
        ],
        listComplementos: [
          ComplementosModel(
              imprimirSeparado: false,
              nombre: 'Complemento chulo asd asdas dsdssssasd',
              categoria: CategoriaModel(nombre: 'Categoria')),
          ComplementosModel(
              imprimirSeparado: false,
              nombre: 'Complemento feo',
              categoria: CategoriaModel(nombre: 'Categoria')),
          ComplementosModel(
              imprimirSeparado: false,
              nombre: 'Complemento malo',
              categoria: CategoriaModel(nombre: 'Categoria')),
        ],
        listExtras: [
          ExtrasModel(
              imprimirSeparado: true,
              nombre: 'Extra chilo',
              precio: 10,
              categoria: CategoriaModel(nombre: 'Categoria')),
          ExtrasModel(
              imprimirSeparado: true,
              nombre: 'Extra feoo',
              precio: 20,
              categoria: CategoriaModel(nombre: 'Categoria')),
          ExtrasModel(
              imprimirSeparado: true,
              nombre: 'Extra malow',
              precio: 30,
              categoria: CategoriaModel(nombre: 'Categoria')),
        ]),
    ProductoModel(
        icono: '2',
        nombre: 'Nombre 2',
        switchMultiple: false,
        categoriaModel: CategoriaModel(nombre: 'Categoria'),
        listVariaciones: [
          VariacionModel(
              subnombre: 'Subnombre', codigo: '', stock: 0, precio: 100)
        ],
        listComplementos: [],
        listExtras: []),
    ProductoModel(
        icono: '3',
        nombre: 'Nombre 3',
        switchMultiple: false,
        categoriaModel: CategoriaModel(nombre: 'Categoria'),
        listVariaciones: [
          VariacionModel(
              subnombre: 'Subnombre', codigo: '', stock: 0, precio: 100)
        ],
        listComplementos: [],
        listExtras: []),
    ProductoModel(
        icono: '4',
        nombre: 'Nombre 4',
        switchMultiple: false,
        categoriaModel: CategoriaModel(nombre: 'Categoria'),
        listVariaciones: [
          VariacionModel(
              subnombre: 'Subnombre', codigo: '', stock: 0, precio: 100)
        ],
        listComplementos: [],
        listExtras: []),
    ProductoModel(
        icono: '5',
        nombre: 'Nombre 5',
        switchMultiple: false,
        categoriaModel: CategoriaModel(nombre: 'Categoria'),
        listVariaciones: [
          VariacionModel(
              subnombre: 'Subnombre', codigo: '', stock: 0, precio: 100)
        ],
        listComplementos: [],
        listExtras: []),
    ProductoModel(
        icono: '6',
        nombre: 'Nombre 6',
        switchMultiple: false,
        categoriaModel: CategoriaModel(nombre: 'Categoria'),
        listVariaciones: [
          VariacionModel(
              subnombre: 'Subnombre', codigo: '', stock: 0, precio: 100)
        ],
        listComplementos: [],
        listExtras: []),
  ];

  abrirEditor(BuildContext context, ProductoModel modelo) {
    final productSelectorProvider =
        Provider.of<ProductSelectorProvider>(context, listen: false);

    productSelectorProvider.establecerModelo(modelo);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductSelectorView()),
    );
  }
}

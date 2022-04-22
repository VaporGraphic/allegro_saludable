import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/views/menu/widgets/item_card/item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponisiveCards {
  String getSize({
    required double currentSize,
  }) {
    if (currentSize <= 200) {
      return 'x-sm';
    } else if (currentSize <= 576) {
      //SMALL
      return 'sm';
    } else if (currentSize <= 768) {
      //MD
      return 'md';
    } else if (currentSize <= 992) {
      //LG
      return 'lg';
    } else if (currentSize <= 1200) {
      //XL
      return 'xl';
    } else {
      //XXL
      return 'xxl';
    }
  }

  int getIntSize(
    int? sm,
    int? md,
    int? lg,
    int? xl,
    int? xxl, {
    required double currentSize,
  }) {
    int closestValue = 1;

    if (currentSize > 0) {
      //X-SMALL
      closestValue = 1;
    }

    if (currentSize > 200) {
      //SMALL
      if (sm != null) {
        closestValue = sm;
      }
    }

    if (currentSize >= 520) {
      //MD
      if (md != null) {
        closestValue = md;
      }
    }

    if (currentSize >= 768) {
      //LG
      if (lg != null) {
        closestValue = lg;
      }
    }

    if (currentSize >= 992) {
      //XL
      if (xl != null) {
        closestValue = xl;
      }
    }

    if (currentSize >= 1400) {
      //XXL
      if (xxl != null) {
        closestValue = xxl;
      }
    }

    return closestValue;
  }

  bool filtroBusqueda(
      {required String busquedaString,
      CategoriaModel? categoriaModel,
      required ProductoModel productoModelo}) {
    int totalEtiquetas = 0;
    int matches = 0;

    if (busquedaString.isNotEmpty) {
      totalEtiquetas++;
    }
    if (categoriaModel != null) {
      totalEtiquetas++;
    }

    if (productoModelo.nombre
            .toLowerCase()
            .contains(busquedaString.toLowerCase()) &&
        busquedaString.isNotEmpty) {
      matches++;
    }

    if (categoriaModel != null) {
      if (productoModelo.categoriaModel.nombre == categoriaModel.nombre &&
          productoModelo.categoriaModel.firebaseId ==
              categoriaModel.firebaseId) {
        matches++;
      }
    }

    print('total $totalEtiquetas - matches $matches');

    if (totalEtiquetas == matches) {
      return true;
    } else {
      return false;
    }
  }

  List<Widget> getList({
    required BuildContext context,
    required List<ProductoModel> listCards,
    required double currentSize,
    required String busquedaString,
    CategoriaModel? categoriaModel,
    int? sm,
    int? md,
    int? lg,
    int? xl,
    int? xxl,
  }) {
    print(getSize(currentSize: currentSize));
    print(getIntSize(
      sm,
      md,
      lg,
      xl,
      xxl,
      currentSize: currentSize,
    ));

    int size = getIntSize(
      sm,
      md,
      lg,
      xl,
      xxl,
      currentSize: currentSize,
    );

    List<Widget> lista = [
      for (var i = 0; i < listCards.length; i = i + size)
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 15),
          child: Row(
            children: [
              for (var j = i; j < i + size; j++)
                j < listCards.length
                    ? ItemCard(
                        mostrar: filtroBusqueda(
                            categoriaModel: categoriaModel,
                            busquedaString: busquedaString,
                            productoModelo:
                                ProductoModel.fromMap(listCards[j].toMap())),
                        modelo: ProductoModel.fromMap(listCards[j].toMap()),
                      )
                    : Expanded(
                        child: Container(),
                      ),
            ],
          ),
        )
    ];

    return lista;
  }
}

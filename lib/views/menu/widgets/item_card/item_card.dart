import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/views/menu/menu_provider.dart';
import 'package:allegro_saludable/views/product_selector/product_selector_view.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ProductoModel modelo;
  final bool mostrar;

  const ItemCard({Key? key, required this.modelo, required this.mostrar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);

    String obtenerPrecios(List<VariacionModel> listaModelos) {
      double precioMenor = listaModelos[0].precio;
      double precioMayor = listaModelos[0].precio;

      for (var item in listaModelos) {
        if (item.precio < precioMenor) {
          precioMenor = item.precio;
        }
        if (item.precio > precioMayor) {
          precioMayor = item.precio;
        }
      }

      if (precioMenor == precioMayor) {
        return '\$$precioMayor';
      } else {
        return '\$$precioMenor - \$$precioMayor';
      }
    }

    return mostrar != false
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Ink(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.20),
                        spreadRadius: 2,
                        blurRadius: 7.5,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                child: InkWell(
                  onTap: () {
                    if (modelo.listVariaciones.length == 1) {
                      menuProvider.abrirEditor(
                          context, modelo, modelo.listVariaciones[0]);
                    } else {
                      menuProvider.seleccionarModeloModal(context, modelo);
                    }
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.all(7.5),
                    child: Column(
                      children: [
                        SpaceY(
                          percent: 2,
                        ),
                        Image(
                          image: AssetImage('assets/icons/${modelo.icono}.png'),
                          height: 75,
                        ),
                        SpaceY(
                          percent: .5,
                        ),
                        Ink(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.shade200),
                          child: TextSmall(
                            '${modelo.categoriaModel.nombre}',
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SpaceY(
                          percent: .5,
                        ),
                        TextNormal(
                          '${modelo.nombre}',
                          fontWeight: FontWeight.bold,
                        ),
                        SpaceY(
                          percent: .5,
                        ),
                        TextLead(
                          modelo.listVariaciones.length > 1
                              ? obtenerPrecios(modelo.listVariaciones)
                              : '\$${modelo.listVariaciones[0].precio}',
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                        ),
                        SpaceY(
                          percent: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}

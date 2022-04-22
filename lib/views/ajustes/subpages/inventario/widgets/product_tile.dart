import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatelessWidget {
  final ProductoModel modelo;
  final int index;

  const ProductTile({
    Key? key,
    required this.modelo,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ajustesInventarioProvider =
        Provider.of<AjustesInventarioProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 7.5),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () {
            ajustesInventarioProvider.showModalOpciones(context, modelo, index);
          },
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/icons/${modelo.icono}.png'),
                height: 50,
              ),
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextSmall(
                  '${modelo.categoriaModel.nombre}',
                  color: Colors.grey,
                ),
                TextNormal('${modelo.nombre}'),
                SpaceY(
                  percent: .25,
                ),
                Row(
                  children: [
                    Ink(
                      padding: EdgeInsets.symmetric(horizontal: 7.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.deepPurpleAccent),
                      child: TextSmall(
                        '${modelo.listVariaciones.length} modelos',
                        color: Colors.white,
                      ),
                    ),
                    modelo.listComplementos.isNotEmpty
                        ? SpaceX(
                            percent: .25,
                          )
                        : Container(),
                    modelo.listComplementos.isNotEmpty
                        ? Ink(
                            padding: EdgeInsets.symmetric(horizontal: 7.5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.deepPurpleAccent),
                            child: TextSmall(
                              '${modelo.listComplementos.length} comps',
                              color: Colors.white,
                            ),
                          )
                        : Container(),
                    SpaceX(
                      percent: .25,
                    ),
                    modelo.listExtras.isNotEmpty
                        ? Ink(
                            padding: EdgeInsets.symmetric(horizontal: 7.5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.deepPurpleAccent),
                            child: TextSmall(
                              '${modelo.listExtras.length} extras',
                              color: Colors.white,
                            ),
                          )
                        : Container()
                  ],
                ),
                SpaceY(
                  percent: .5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

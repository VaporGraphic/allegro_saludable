import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/views/editor/inventario/subpages/complementos/editor_inventario_complementos_provider.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditorInventarioComplementosView extends StatelessWidget {
  const EditorInventarioComplementosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editorInventarioComplementosProvider =
        Provider.of<EditorInventarioComplementosProvider>(context);

    final editorInventarioProvider =
        Provider.of<EditorInventarioProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        editorInventarioProvider.updateGeneral(context);
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            editorInventarioComplementosProvider.abirEditor(context);
          },
          child: Icon(Icons.add_rounded),
        ),
        appBar: AppBarWidget(
          title: 'Editar complementos',
        ),
        body: ListView(
          padding: EdgeInsets.all(15),
          children: [
            TextTitle(
                'Editar complementos (${editorInventarioProvider.productoEditable.listComplementos.length})'),
            Text('Productos que se regalan junto con tu producto'),
            SpaceY(),
            for (var i = 0;
                i <
                    editorInventarioProvider
                        .productoEditable.listComplementos.length;
                i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ListTile(
                  onTap: () {
                    editorInventarioComplementosProvider.abirEditor(context,
                        index: i,
                        modelo: ComplementosModel.fromMap(
                            editorInventarioProvider
                                .productoEditable.listComplementos[i]
                                .toMap()));
                  },
                  leading: Icon(Icons.grid_view_outlined),
                  title: Padding(
                    padding: const EdgeInsets.all(7.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSmall(editorInventarioProvider.productoEditable
                            .listComplementos[i].categoria.nombre),
                        Text(editorInventarioProvider
                            .productoEditable.listComplementos[i].nombre),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

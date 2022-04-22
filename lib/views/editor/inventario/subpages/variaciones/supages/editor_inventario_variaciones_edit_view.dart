import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/views/editor/inventario/editor_inventario_provider.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:allegro_saludable/widgets/appbar/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditorInventarioVariacionesEditView extends StatelessWidget {
  const EditorInventarioVariacionesEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editorInventarioProvider =
        Provider.of<EditorInventarioProvider>(context);

    final editorInventarioVariacionesProvider =
        Provider.of<EditorInventarioVariacionesProvider>(context);

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75),
        child: FloatingActionButton(
          onPressed: () {
            editorInventarioVariacionesProvider.abrirEditorGenerador(context);
          },
          child: Icon(Icons.add),
        ),
      ),
      appBar: AppBarWidget(
        title: 'Generador variaciones',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(15),
              physics: BouncingScrollPhysics(),
              children: [
                TextTitle(
                    'Generar variaciones (${editorInventarioProvider.productoEditable.listGeneradores.length})'),
                Text('Genera modelos a partir de texto'),
                SpaceY(),
                for (var i = 0;
                    i <
                        editorInventarioProvider
                            .productoEditable.listGeneradores.length;
                    i++)
                  TileGenerador(
                    editorInventarioProvider: editorInventarioProvider,
                    i: i,
                    onTap: () {
                      editorInventarioVariacionesProvider.abrirEditorGenerador(
                          context,
                          index: i,
                          modelo: GeneradorModel.fromMap(
                              editorInventarioProvider
                                  .productoEditable.listGeneradores[i]
                                  .toMap()));
                    },
                  )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: editorInventarioProvider
                        .productoEditable.listGeneradores.isNotEmpty
                    ? () {
                        editorInventarioVariacionesProvider
                            .comprobarVariaciones(context);
                      }
                    : null,
                child: TextNormal(
                  'Generar variaciones',
                  fontWeight: FontWeight.bold,
                )),
          )
        ],
      ),
    );
  }
}

class TileGenerador extends StatelessWidget {
  final VoidCallback onTap;
  final EditorInventarioProvider editorInventarioProvider;
  final int i;

  const TileGenerador({
    Key? key,
    required this.editorInventarioProvider,
    required this.i,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String modelos = '';

    for (var modelo in editorInventarioProvider
        .productoEditable.listGeneradores[i].listModelos) {
      modelos += '$modelo, ';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        onTap: onTap,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextSmall(
                  '${editorInventarioProvider.productoEditable.listGeneradores[i].titulo} (${editorInventarioProvider.productoEditable.listGeneradores[i].listModelos.length})'),
              Text('$modelos')
            ],
          ),
        ),
      ),
    );
  }
}

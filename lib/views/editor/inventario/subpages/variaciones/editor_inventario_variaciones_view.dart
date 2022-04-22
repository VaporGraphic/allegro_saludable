import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/views/editor/inventario/editor_inventario_provider.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:allegro_saludable/widgets/appbar/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditorInventarioVariacionesView extends StatelessWidget {
  const EditorInventarioVariacionesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editorInventarioProvider =
        Provider.of<EditorInventarioProvider>(context);

    final editorInventarioVariacionesProvider =
        Provider.of<EditorInventarioVariacionesProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        editorInventarioProvider.updateGeneral(context);
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            editorInventarioVariacionesProvider.abrirGenerador(context);
          },
          child: Icon(Icons.edit),
        ),
        appBar: AppBarWidget(
          title: 'Editar variaciones',
        ),
        body: ListView(
          padding: EdgeInsets.all(15),
          physics: BouncingScrollPhysics(),
          children: [
            TextTitle(
                'Editar variaciones (${editorInventarioProvider.productoEditable.listVariaciones.length})'),
            Text('Modelos generados'),
            SpaceY(),
            SwitchListTile(
                title: Text('Monitorear inventario'),
                value: editorInventarioProvider.productoEditable.switchStock,
                onChanged: (value) {
                  editorInventarioProvider.toogleStock(value);
                }),
            SpaceY(),
            for (var i = 0;
                i <
                    editorInventarioProvider
                        .productoEditable.listVariaciones.length;
                i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ListTile(
                  onTap: () {
                    editorInventarioVariacionesProvider.abrirEditorVariantes(
                        context,
                        VariacionModel.fromMap(editorInventarioProvider
                            .productoEditable.listVariaciones[i]
                            .toMap()),
                        i);
                  },
                  leading: Icon(Icons.layers_outlined),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSmall(editorInventarioProvider
                                    .productoEditable.switchStock ==
                                true
                            ? 'Codigo: "${editorInventarioProvider.productoEditable.listVariaciones[i].codigo}", Stock ${editorInventarioProvider.productoEditable.listVariaciones[i].stock}'
                            : 'Codigo: "${editorInventarioProvider.productoEditable.listVariaciones[i].codigo}"'),
                        TextNormal(
                            '${editorInventarioProvider.productoEditable.listVariaciones[i].subnombre}'),
                      ],
                    ),
                  ),
                  trailing: TextNormal(
                    '\$${editorInventarioProvider.productoEditable.listVariaciones[i].precio}',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

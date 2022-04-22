import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/oktoast/oktoast_service.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditorInventarioExtrasView extends StatelessWidget {
  const EditorInventarioExtrasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editorInventarioExtrasProvider =
        Provider.of<EditorInventarioExtrasProvider>(context);

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
            editorInventarioExtrasProvider.abirEditor(context);
          },
          child: Icon(Icons.add_rounded),
        ),
        appBar: AppBarWidget(
          title: 'Editar extras',
        ),
        body: ListView(
          padding: EdgeInsets.all(15),
          children: [
            TextTitle(
                'Editar extras (${editorInventarioProvider.productoEditable.listExtras.length})'),
            Text('Productos que se venden junto con tu producto'),
            SpaceY(),
            for (var i = 0;
                i < editorInventarioProvider.productoEditable.listExtras.length;
                i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ListTile(
                  onTap: () {
                    editorInventarioExtrasProvider.abirEditor(context,
                        index: i,
                        modelo: ExtrasModel.fromMap(editorInventarioProvider
                            .productoEditable.listExtras[i]
                            .toMap()));
                  },
                  leading: Icon(Icons.grid_view_outlined),
                  title: Padding(
                    padding: const EdgeInsets.all(7.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSmall(editorInventarioProvider
                            .productoEditable.listExtras[i].categoria.nombre),
                        Text(editorInventarioProvider
                            .productoEditable.listExtras[i].nombre),
                      ],
                    ),
                  ),
                  trailing: TextNormal(
                    '\$${editorInventarioProvider.productoEditable.listExtras[i].precio}',
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

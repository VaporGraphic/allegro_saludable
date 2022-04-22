import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/views/ajustes/subpages/usuarios/subpages/ajustes_usuarios_edit_provider.dart';
import 'package:allegro_saludable/views/ajustes/subpages/usuarios/subpages/ajustes_usuarios_edit_view.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AjustesUsuariosProvider extends ChangeNotifier {
  mostrarOpciones(
      {required UsuariosModel usuario, required BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextLead('Opciones:'),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close),
                      )
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      editarUsuario(usuario, context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SpaceX(),
                        Text('Editar usuario')
                      ],
                    )),
                TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline),
                        SpaceX(),
                        Text('Eliminar usuario')
                      ],
                    )),
              ],
            ),
          );
        });
  }

  editarUsuario(UsuariosModel usuario, BuildContext context) {
    final ajustesUsuariosEditProvider =
        Provider.of<AjustesUsuariosEditProvider>(context, listen: false);

    Navigator.pop(context);

    ajustesUsuariosEditProvider.establecerUsuario(
        editar: true, usuario: UsuariosModel.fromMap(usuario.toMap()));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AjustesUsuariosEditView()),
    );
  }
}

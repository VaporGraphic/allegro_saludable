import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/firebase/usuarios/usuarios_crud_service.dart';
import 'package:allegro_saludable/views/ajustes/subpages/usuarios/ajustes_usuarios_provider.dart';
import 'package:allegro_saludable/views/ajustes/subpages/usuarios/subpages/ajustes_usuarios_edit_provider.dart';
import 'package:allegro_saludable/views/ajustes/subpages/usuarios/subpages/ajustes_usuarios_edit_view.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AjustesUsuariosView extends StatelessWidget {
  const AjustesUsuariosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ajustesUsuariosEditProvider =
        Provider.of<AjustesUsuariosEditProvider>(context);

    final ajustesUsuariosProvider =
        Provider.of<AjustesUsuariosProvider>(context);

    final usuariosCrudService = Provider.of<UsuariosCrudService>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            ajustesUsuariosEditProvider.establecerUsuario(editar: false);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AjustesUsuariosEditView()),
            );
          }),
      appBar: AppBarWidget(
        title: 'Ajustes Usuarios',
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        physics: BouncingScrollPhysics(),
        children: [
          TextTitle('Ajustes usuarios'),
          Text('Administrar tus colaboradores'),
          SpaceY(),
          if (usuariosCrudService.listUsuarios != null)
            for (var usuario in usuariosCrudService.listUsuarios!)
              Padding(
                padding: const EdgeInsets.only(bottom: 7.5),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          usuario.admin == true
                              ? Icons.account_circle_outlined
                              : Icons.people_outlined,
                          color: usuario.admin == true
                              ? Colors.deepPurpleAccent
                              : Colors.grey,
                        ),
                      ],
                    ),
                    title: Text('${usuario.usuario}'),
                    subtitle: Text(usuario.admin == true
                        ? 'Administrador'
                        : 'Colaborador'),
                    onTap: () {
                      ajustesUsuariosProvider.mostrarOpciones(
                          usuario: UsuariosModel.fromMap(usuario.toMap()),
                          context: context);
                    },
                  ),
                ),
              )
        ],
      ),
    );
  }
}

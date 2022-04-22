import 'package:allegro_saludable/services/firebase/usuarios/usuarios_crud_service.dart';
import 'package:allegro_saludable/views/ajustes/subpages/usuarios/subpages/ajustes_usuarios_edit_provider.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AjustesUsuariosEditView extends StatelessWidget {
  const AjustesUsuariosEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ajustesUsuariosEditProvider =
        Provider.of<AjustesUsuariosEditProvider>(context);

    final usuariosCrudService = Provider.of<UsuariosCrudService>(context);

    return Scaffold(
      appBar: AppBarWidget(
        title: ajustesUsuariosEditProvider.editarUsuario == false
            ? 'Crear usuario'
            : 'Editar Usuario',
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
                child: ListView(
              padding: EdgeInsets.all(15),
              children: [
                TextTitle('Datos usuario'),
                Text('Informacion de inicio de sesion'),
                SpaceY(),
                SwitchListTile(
                    title: Text('¿Es administrador el usuario?'),
                    value: ajustesUsuariosEditProvider
                        .modeloUsuarioEditable.admin!,
                    onChanged: (value) {
                      ajustesUsuariosEditProvider.toogleAdmin(value);
                    }),
                SpaceY(),
                TextField(
                  textInputAction: TextInputAction.next,
                  controller: ajustesUsuariosEditProvider.userController,
                  decoration: InputDecoration(
                      hintText: 'Nombre del usuario',
                      prefixIcon: Icon(Icons.person_outlined)),
                ),
                SpaceY(),
                TextField(
                  controller: ajustesUsuariosEditProvider.passwrodController,
                  decoration: InputDecoration(
                      hintText: 'Clave de ingreso',
                      prefixIcon: Icon(Icons.lock_outlined)),
                ),
              ],
            )),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                  onPressed: () {
                    if (ajustesUsuariosEditProvider.editarUsuario == false) {
                      ajustesUsuariosEditProvider.crearUsuario(context);
                    } else {
                      print('editar');
                    }
                  },
                  child: Text(ajustesUsuariosEditProvider.editarUsuario == false
                      ? 'Crear usuario'
                      : 'Guardar datos')),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/firebase/usuarios/usuarios_crud_service.dart';
import 'package:allegro_saludable/services/oktoast/oktoast_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AjustesUsuariosEditProvider extends ChangeNotifier {
  UsuariosModel modeloUsuarioEditable = UsuariosModel();
  bool editarUsuario = false;

  TextEditingController userController = TextEditingController();
  TextEditingController passwrodController = TextEditingController();

  establecerUsuario({required bool editar, UsuariosModel? usuario}) {
    if (editar == true) {
      editarUsuario = true;
      modeloUsuarioEditable = usuario!;
    } else {
      editarUsuario = false;
      modeloUsuarioEditable = UsuariosModel(
          admin: false, firebaseId: '', password: '', usuario: '');
    }

    userController.text = modeloUsuarioEditable.usuario!;
    passwrodController.text = modeloUsuarioEditable.password!;

    notifyListeners();
  }

  toogleAdmin(bool value) {
    modeloUsuarioEditable.admin = value;
    notifyListeners();
  }

  crearUsuario(BuildContext context) {
    final usuariosCrudService =
        Provider.of<UsuariosCrudService>(context, listen: false);

    final okToastService = Provider.of<OkToastService>(context, listen: false);

    if (userController.text.isEmpty || passwrodController.text.isEmpty) {
      okToastService.showOkToast(mensaje: 'Rellena todos los campos');
    } else {
      modeloUsuarioEditable.usuario = userController.text;
      modeloUsuarioEditable.password = passwrodController.text;

      usuariosCrudService.agregarUsuario(
          context, UsuariosModel.fromMap(modeloUsuarioEditable.toMap()));
    }
  }
}

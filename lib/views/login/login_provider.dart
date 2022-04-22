import 'package:allegro_saludable/services/firebase/usuarios/usuarios_crud_service.dart';
import 'package:allegro_saludable/services/oktoast/oktoast_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginProvider extends ChangeNotifier {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  iniciarSesion(BuildContext context) {
    final usuariosCrudService =
        Provider.of<UsuariosCrudService>(context, listen: false);

    final okToastService = Provider.of<OkToastService>(context, listen: false);

    if (userController.text.isNotEmpty && userController.text.isNotEmpty) {
      usuariosCrudService.loginUser(
          context, userController.text, passwordController.text);
    } else {
      okToastService.showOkToast(mensaje: 'Rellenar todos los campos');
    }
  }
}

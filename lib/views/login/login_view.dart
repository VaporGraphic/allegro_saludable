import 'package:allegro_saludable/services/firebase/usuarios/usuarios_crud_service.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuariosCrudService = Provider.of<UsuariosCrudService>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/brand/logo.png'),
                height: 150,
              ),
              SpaceY(
                percent: 2,
              ),
              TextTitle(
                'Bienvenido',
              ),
              TextNormal(
                'Ingresa tus datos de usuario',
              ),
              SpaceY(),
              TextField(
                controller: loginProvider.userController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outlined),
                    hintText: 'Nombre de usuario'),
              ),
              SpaceY(),
              TextField(
                controller: loginProvider.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outlined),
                    hintText: 'Clave de ingreso'),
              ),
              SpaceY(
                percent: 2,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      loginProvider.iniciarSesion(context);
                    },
                    child: Text('Ingresar al sistema')),
              ),
              Container(
                width: double.infinity,
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

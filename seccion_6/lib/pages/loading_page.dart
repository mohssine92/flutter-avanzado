import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// providers
import 'package:seccion_6/services/auth_service.dart';

// pages
import 'package:seccion_6/pages/login_page.dart';
import 'package:seccion_6/pages/usuarios_page.dart';

// Esta pantalla me ayuda tomar la decision si el token valido le mando a pantalla usuarios - sino al login para autenticarse
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  FutureBuilder para dispara future
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      // TODO: conectar al socket server
      // Navigator.pushReplacementNamed(context, 'usuarios');
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => UsuariosPage(),
              transitionDuration: const Duration(milliseconds: 0)));
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginPage(),
              transitionDuration: const Duration(milliseconds: 0)));
    }
  }
}

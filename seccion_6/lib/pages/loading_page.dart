import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// providers
import 'package:seccion_6/services/auth_service.dart';

// pages
import 'package:seccion_6/pages/login_page.dart';
import 'package:seccion_6/pages/usuarios_page.dart';
import 'package:seccion_6/services/socket_service.dart';

// Esta pantalla me ayuda tomar la decision si el token valido le mando a pantalla usuarios - sino al login para autenticarse
// No olvidar - refresh == cierra la y abrirse de nuevo : siempre caemos en esta pantalla inicial
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
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      // Refresh de la app usuario cierra la app y vuelva a entrar - es decir server node pierde la conexion socket - puesto token aun valido conectamos tambien
      socketService.connect();
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

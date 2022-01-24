import 'package:flutter/material.dart';

// Pages
import 'package:seccion_6/pages/chat_page.dart';
import 'package:seccion_6/pages/loading_page.dart';
import 'package:seccion_6/pages/login_page.dart';
import 'package:seccion_6/pages/register_d_page.dart';
//import 'package:seccion_6/pages/register_1_page.dart';
import 'package:seccion_6/pages/register_page.dart';
import 'package:seccion_6/pages/usuarios_page.dart';

// Todas las definiciones de las rutas que va manejar mi applicacion
final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => UsuariosPage(),
  'chat': (_) => ChatPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
  'register_delivery': (_) => Register_d_Page(),
};

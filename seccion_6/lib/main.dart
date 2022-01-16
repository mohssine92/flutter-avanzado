import 'package:flutter/material.dart';

// Definicin de rutas de la app
import 'package:seccion_6/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: appRoutes,
    );
  }
}

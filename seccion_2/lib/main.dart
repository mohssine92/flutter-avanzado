import 'package:flutter/material.dart';

import 'package:seccion_2/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      // ( _ ) : no vamos a injectar context - no lo vamos a usar
      routes: {'home': (_) => Homepage()},
    );
  }
}

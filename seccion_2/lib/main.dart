import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

//pages
import 'package:seccion_2/pages/home.dart';
import 'package:seccion_2/pages/status.dart';

// services
import 'package:seccion_2/services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {'home': (_) => Homepage(), 'status': (_) => StatusPage()},
      ),
    );
  }
}

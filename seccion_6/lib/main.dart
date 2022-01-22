import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// Definicion rutas principales de la app
import 'package:seccion_6/routes/routes.dart';

// Services
import 'package:seccion_6/services/auth_service.dart';
import 'package:seccion_6/services/chat_service.dart';
import 'package:seccion_6/services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Injectar Services - de manera que se pueden usarse de Forma Global en  la app Usando provider - 92
      // Implementarlo en esta altura : es decir todos widgets van a tener en su context los providers Injectados en esta altura
      providers: [
        // coleccion de classes de tipo provider
        // Ventaja Provider : AuthService() : crear instancia global , es un singlton - TAmbien va notificale a los widgets necesarios cuado quiero redibujarlos
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}



// --no-sound-null-safety arg run app 
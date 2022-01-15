import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// Una clase va expandir la comunicacion con el servidor socket en cualquier parte de mi app donde yo lo necesito . y va ayudarme a Trabajar con provider

// Crear enumeracion para manejar estado del server socket
enum ServerStatus { Online, Offline, Connecting }

// mixar  with ChangeNotifier : ayuda a decir al provider cuando refresca , redibujar UX
// para crear Instancia de Nuestro SocketService : usamos provider
class SocketService with ChangeNotifier {
  // La hemos puesto como prop privada : con fin de controlar la manera como se va utulizarse esta prop es decir su valo se cambia solo dentro de esa clase -
  // para cambiar su valor desde  Fuera requiere un seter y no es el caso .
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  // GETERS - con geter se expone prop private a fueras utulizaciones
  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  // Constructor
  SocketService() {
    _initConfig();
  }

  // metodo privada - no refresa nada
  void _initConfig() {
    // Dart client --- Connection ----
    _socket = IO.io('http://192.168.1.58:3009', {
      //: 3004
      'transports': ['websocket'],
      'autoConnect':
          true // connect de manera automatica - o un momento especifico que necesitamos
    });

    //--------------LISTENNERSS-------------------//

    _socket.on('connect', (_) {
      // print('connect');
      _serverStatus = ServerStatus.Online;
      // al llamar  notifyListeners(); va redibujar en cualquier lugar en la app depende de este cambio porque este modelo mixado con ... esta injectado en nivel alto en la app
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      // print('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    //-------------------------------------------//
  }
}

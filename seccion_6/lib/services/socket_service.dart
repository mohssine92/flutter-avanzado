import 'package:flutter/material.dart';
import 'package:seccion_6/services/auth_service.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

// Variabels entorno
import 'package:seccion_6/global/environment.dart';

// Una clase va expandir la comunicacion con el servidor socket en cualquier parte de mi app donde yo lo necesito . y va ayudarme a Trabajar con provider

// Crear enumeracion para manejar estado del server socket
enum ServerStatus { Online, Offline, Connecting }

// mixar  with ChangeNotifier : ayuda a decir al provider cuando refresca , redibujar UX
class SocketService with ChangeNotifier {
  // La hemos puesto como prop privada : con fin de controlar la manera como se va utulizarse esta prop es decir su valo se cambia solo dentro de esa clase -
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  // GETERS - con geter se expone prop private a fueras utulizaciones
  ServerStatus get serverStatus =>
      _serverStatus; // => la occupo para redibujar simbolos - Ternarios de widgets
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  // Genial : nuestro cliente  flutter va connectar unicamente cuando disparamos esta funcion es decir tenemos control total de cuando se conecta socket y se disconnecta
  void connect() async {
    // Storage - get
    final token = await AuthService.getToken();

    // Dart client --- Connection ----
    _socket = IO.io(Environment.socketUrl, {
      //  http://192.168.1.58:3009
      //: 3004
      'transports': ['websocket'],
      'autoConnect':
          true, // connect de manera automatica - o un momento especifico que necesitamos
      'forceNew':
          true, // new instance al - si occupamos autentcacion por socket
      'extraHeaders': {'x-token': token}
    });

    //--------------LISTENNERSS-------------------//

    _socket.on('connect', (_) {
      print('connect');
      _serverStatus = ServerStatus.Online;
      // al llamar  notifyListeners(); va redibujar en cualquier lugar en la app depende de este cambio porque este modelo mixado con ... esta injectado en nivel alto en la app
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      print('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    //-------------------------------------------//
  }

  // Desconnectar Socket comunicacion - cuando hago logout
  // Esta funcion deberia dispara event disconnected
  void disconnect() {
    _socket.disconnect();
  }
}

import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.1.58:3000/api'
      : 'http://localhost:3000/api';
  static String socketUrl =
      Platform.isAndroid ? 'http://192.168.1.58:3000' : 'http://localhost:3000';
}

// Clase con metodos staticos - Al ser metodos estaticos segnifica que puede acceder a ellas si instancia de la claseR
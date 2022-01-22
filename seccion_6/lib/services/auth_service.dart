import 'dart:convert';
// Storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// Variables de entorno
import 'package:seccion_6/global/environment.dart';

// Model para mapear
import 'package:seccion_6/models/login_response.dart';

// Models
import 'package:seccion_6/models/usuario.dart';

// Class Normal : al mezaclar con ChangeNotifier sera Provider - asi AuthService es provider
class AuthService with ChangeNotifier {
  // Crear Instance Storage - la pongo privado
  final _storage = const FlutterSecureStorage();
  Usuario? usuario;

  // privada - requiere getetrs - setters , objetivo implementar listeners : es decir cualquier widget esta escuchando AuthService va ser notificado y redibujado : uno de los usos  de provider
  bool _autenticando = false;
  bool get autenticando => _autenticando; // getter
  set autenticando(bool valor) {
    // seter
    _autenticando = valor;
    //  por eso uso setters , para dispara el notificador del provider  notifyListeners();
    notifyListeners();
  }

  // get del token de forma estática - uso: aveces quiero acceder al token si instanciar provider ..
  // uso de static no me permite acceso a las props de la clase - por eso nueva instancia const _storage = FlutterSecureStorage();
  static Future<String> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token') ?? '';
    return token;
  }

  // otra forma de borra desde fuera de la clase - acceso facil statico
  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;

    // Payload a mandar a backend
    final data = {'email': email, 'password': password};

    final uri = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    //print(resp.body);

    autenticando = false;

    if (resp.statusCode == 200) {
      // res.body  nos lo entrega como string paquete de http
      final loginResponse = LoginResponse.fromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      // false es algo salio mal - implemnetar alerta y mostrar err de la base de datos
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    autenticando = true;

    final data = {'nombre': nombre, 'email': email, 'password': password};

    final uri = Uri.parse('${Environment.apiUrl}/login/new');
    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token') ?? '';

    final uri = Uri.parse('${Environment.apiUrl}/login/renew');
    final resp = await http.get(uri,
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    // eleminar solo uno - ver doc se puede eleminar todos
    await _storage.delete(key: 'token');
  }
}

// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:seccion_6/models/usuario.dart';

class LoginResponse {
  LoginResponse({
    required this.ok,
    required this.usuario,
    required this.token,
  });

  bool ok;
  Usuario usuario;
  String token;

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"] ?? '',
        usuario: Usuario.fromMap(json["usuario"]),
        token: json["token"] ?? '',
      );
}

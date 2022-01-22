// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

class Usuario {
  Usuario({
    required this.online,
    required this.nombre,
    required this.email,
    required this.uid,
  });

  bool online;
  String nombre;
  String email;
  String uid;

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        online: json["online"] ?? '',
        nombre: json["nombre"] ?? '',
        email: json["email"] ?? '',
        uid: json["uid"],
      );
}

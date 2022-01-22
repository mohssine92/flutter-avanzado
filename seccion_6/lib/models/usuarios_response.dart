import 'dart:convert';

import 'package:seccion_6/models/usuario.dart';

class UsuariosResponse {
  UsuariosResponse({
    required this.ok,
    required this.usuarios,
  });

  bool ok;
  List<Usuario> usuarios;

  factory UsuariosResponse.fromJson(String str) =>
      UsuariosResponse.fromMap(json.decode(str));

  factory UsuariosResponse.fromMap(Map<String, dynamic> json) =>
      UsuariosResponse(
          ok: json["ok"] ?? '',
          usuarios: List<Usuario>.from(
              json["usuarios"].map((x) => Usuario.fromMap(x))));
}

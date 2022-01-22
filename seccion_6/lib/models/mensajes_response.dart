// To parse this JSON data, do
//
//     final mensajeResponse = mensajeResponseFromJson(jsonString);

import 'dart:convert';

MensajeResponse mensajeResponseFromJson(String str) =>
    MensajeResponse.fromJson(json.decode(str));

class MensajeResponse {
  MensajeResponse({
    required this.ok,
    required this.mensajes,
  });

  bool ok;
  List<Mensaje> mensajes;

  factory MensajeResponse.fromJson(Map<String, dynamic> json) =>
      MensajeResponse(
        ok: json["ok"] ?? '',
        mensajes: List<Mensaje>.from(
            json["mensajes"].map((x) => Mensaje.fromJson(x))),
      );
}

class Mensaje {
  Mensaje({
    required this.de,
    required this.para,
    required this.mensaje,
    required this.createdAt,
    required this.updatedAt,
  });

  String de;
  String para;
  String mensaje;
  DateTime createdAt;
  DateTime updatedAt;

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        de: json["de"] ?? '',
        para: json["para"] ?? '',
        mensaje: json["mensaje"] ?? '',
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}

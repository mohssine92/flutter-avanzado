import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Models
import 'package:seccion_6/models/mensajes_response.dart';

import 'package:seccion_6/global/environment.dart';

// Modelos -
import 'package:seccion_6/models/usuario.dart';
import 'package:seccion_6/services/auth_service.dart';

// Este va ser un Provider - un servicio que notifica a los hijos cuando algo cambia - sera injectado en punto alto en al app
// en este caso uso para restablecer data que voy a recupera en la pantalla al que voy a rederegir , asi sin usar mandar args al widget pantalla destino

class ChatService with ChangeNotifier {
  late Usuario usuarioPara; // usuario destino en mensajeria chat

  /// Recupera mensajes de chat entres jwt - user destino
  Future<List<Mensaje>> getChat(String usuarioID) async {
    final uri = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID');
    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    });

    final mensajesResp = mensajeResponseFromJson(resp.body);

    return mensajesResp.mensajes;
  }
}

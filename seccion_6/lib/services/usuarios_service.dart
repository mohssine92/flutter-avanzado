import 'package:http/http.dart' as http;

// as alias: Tener toda paq0ete centralizado en http
// 110. Servicio para retornar los usuarios

// Models
import 'package:seccion_6/models/usuario.dart';
import 'package:seccion_6/models/usuarios_response.dart';

// Service
import 'package:seccion_6/services/auth_service.dart';

// Variabels entorno
import 'package:seccion_6/global/environment.dart';

// No es neceseriamente usar changeNotifier - veremos otra forma de uso
class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/usuarios');

      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      UsuariosResponse usuariosResponse = UsuariosResponse.fromJson(resp.body);

      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}

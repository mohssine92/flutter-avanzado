import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models - service
import 'package:seccion_2/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // usar chageNotifierProvider , injector de Modelos - Buscar Un Modelo Fue recientemente Injectado en la app
    // en esta version - se instancia el modelo  SocketService
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ServerStatus: ${socketService.serverStatus}')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.message),
          onPressed: () {
            socketService.emit('emitir-mensaje',
                {'nombre': 'Flutter', 'mensaje': 'Hola desde Flutter'});
          }),
    );
  }
}

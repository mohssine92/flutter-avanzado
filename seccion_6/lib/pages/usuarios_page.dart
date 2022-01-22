import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//pull_to_refresh: ^2.0.0
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Models
import 'package:seccion_6/models/usuario.dart';

// Provider
import 'package:seccion_6/services/auth_service.dart';
import 'package:seccion_6/services/chat_service.dart';
import 'package:seccion_6/services/socket_service.dart';
import 'package:seccion_6/services/usuarios_service.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  // pull_to_refresh: ^2.0.0
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // Es classe no implementada provider ni changenotifier - no injectada en la  - solo tiene funcion async a disparara
  final usuarioService = UsuariosService();

  // la rellanamos atraves peticion http
  List<Usuario> usuarios = [];

  @override
  void initState() {
    // Traer lista de usuarios
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(usuario?.nombre ?? 'Sin Nombre',
              style: const TextStyle(color: Colors.black87)),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.black87),
            onPressed: () {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              // no instance  provider , i m using stattic
              AuthService.deleteToken();
            },
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              // notar dif - si se cae el servidor - puede implemenar otros casos : ternario relacionar solo a conexion socker - es decir seguir loguedo pero
              // disconnectado del chat igual como have facebook
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? Icon(Icons.check_circle, color: Colors.blue[400])
                  : const Icon(Icons.offline_bolt, color: Colors.red),
            )
          ],
        ),
        // // pull_to_refresh: ^2.0.0
        body: SmartRefresher(
          controller: _refreshController,
          child: _listviewUsuarios(),
          header: WaterDropHeader(
            complete: Icon(Icons.check, color: Colors.blue[400]),
            waterDropColor: Colors.blue[400]!,
          ),
          enablePullDown: true,
          // que es lo que voy a hacer cuando hago pul to refresh
          onRefresh: _cargarUsuarios,
        ));
  }

  ListView _listviewUsuarios() {
    return ListView.separated(
        // quiero que se vea igual tanto androis como ios - pngo   physics: const BouncingScrollPhysics(),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: usuarios.length);
  }

  // Metodo extraida :  privada returna el tipo ListTile
  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: usuario.online ? Colors.green[300] : Colors.red,
              borderRadius: BorderRadius.circular(100)),
        ),
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara = usuario;
          // permite rederigir y  regresar a pantalla
          Navigator.pushNamed(context, 'chat');
        });
  }

  // metodo privado - vatraer algo de algun end-point
  _cargarUsuarios() async {
    // lo que hace espera un segundo y luego llama a refresh completed - (fictisio) - asi  _refreshController.refreshCompleted() : cuando se dispara se cierra la animacion de espera de traer la data en vida real lo que tarda peticion asyn http en traer data
    // await Future.delayed(Duration(milliseconds: 1000));

    usuarios = await usuarioService.getUsuarios();
    setState(() {});

    _refreshController.refreshCompleted();
  }
}

import 'package:flutter/material.dart';

//pull_to_refresh: ^2.0.0
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Models
import 'package:seccion_6/models/usuario.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  // pull_to_refresh: ^2.0.0
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: '1', nombre: 'María', email: 'test1@test.com', online: true),
    Usuario(
        uid: '2', nombre: 'Melissa', email: 'test2@test.com', online: false),
    Usuario(
        uid: '3', nombre: 'Fernando', email: 'test3@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              const Text('Mi Nombre', style: TextStyle(color: Colors.black87)),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.black87),
            onPressed: () {
              print('pres');
            },
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(Icons.check_circle, color: Colors.blue[400]),
              // child: Icon( Icons.offline_bolt, color: Colors.red ),
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
    );
  }

  // metodo privado - vatraer algo de algun end-point
  _cargarUsuarios() async {
    // lo que hace espera un segundo y luego llama a refresh completed - (fictisio) - asi  _refreshController.refreshCompleted() : cuando se dispara se cierra la animacion de espera de traer la data en vida real lo que tarda peticion asyn http en traer data
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}

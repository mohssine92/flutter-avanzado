import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:seccion_2/models/band.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'Héroes del Silencio', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
          // itemCount : basicamente lo que occupamos para crear cada uno de los elementos bajo demanda
          itemCount: bands.length,
          itemBuilder: (context, i) => _bandTile(bands[i])),
      // button ubicada abajo derecha
      floatingActionButton: FloatingActionButton(
          // onPressed: addNewBand : noten mando solo ref del metodo addNewBand : es decir tiempo de ejecuccion es tiempo de accion
          // si occupo manda args en el mismo ejemplo ser asi : (args..) => addNewBand()
          child: const Icon(Icons.add),
          elevation: 1,
          onPressed: () => addNewBand(context)),
    );
  }

// _bandTile Extaredo como  metodo return widget

  Widget _bandTile(Band band) {
    // 12. Borrar una banda - Dismissible - animacion de elminacion
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      //  onDismissed : se dispara cuando hago todo Movimiento
      onDismissed: (direction) {
        print('direction: $direction');
        print('id: ${band.id}');
        // TODO: llamar el borrado en el server backend - borrada data de la memoria
      },
      background: Container(
          // podemos implemnentar lo que sea aqui basura etc ... puesto que sea widget
          padding: const EdgeInsets.only(left: 8.0),
          color: Colors.red,
          //Align : alinear elementos eneste caso text
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Delete Band', style: TextStyle(color: Colors.white)),
          )),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand(BuildContext context) {
    // Obtener lo se escribe TextField
    final textController = TextEditingController();

    // condicion Mostracion dialog para android
    if (Platform.isAndroid) {
      // Muestra dialogo : viene propio de Flutter
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                  child: Text('Add'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(textController.text, context))
            ],
          );
        },
      );
    }

    // Condicion Mostracion dialog para ios : cupportino
    if (Platform.isIOS) {
      return showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: const Text('New band name:'),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text('Add'),
                    onPressed: () => addBandToList(textController.text, _)),
                CupertinoDialogAction(
                    // isDestructiveAction : ayuda cuando click en enter disparara la accion en dispositivo fisico
                    isDestructiveAction: true,
                    child: const Text('Dismiss'),
                    // en ios no se cierra por defecto si das click fuera - implementamos button de cierre del dialogo
                    onPressed: () => Navigator.pop(context))
              ],
            );
          });
    }
  }

  addBandToList(String name, context) {
    print(name);

    if (name.length > 1) {
      // Podemos agregar a list band - no es vacio
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      // ver cambios _ como estamos en statefulwidget ... rederiza los cambios : redibujar
      setState(() {});
    }

    // cerrar ese dialogo
    Navigator.pop(context);
  }
}

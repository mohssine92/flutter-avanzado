import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:pie_chart/pie_chart.dart';

import 'package:seccion_2/models/band.dart';
import 'package:seccion_2/services/socket_service.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Band> bands = [];

  // Hook
  @override
  void initState() {
    // listen: false : desahabilatar notificar cambios de props del modelo recibido Socketservice
    final socketService = Provider.of<SocketService>(context, listen: false);

    // iniciar escucha del evento active-bands
    socketService.socket.on('active-bands', _handleActiveBands);
    // redibujar - al mutar prop del statefulwidget : bands
    super.initState();
  }

  // metodo privada
  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();

    setState(() {});
  }

  // Hook _ cuando se destroce el widget
  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    // terminar escuahe del evento - active-bands
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : const Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _showGraph(),
          Expanded(
            // expanded obligatorio para list.view funcione en col - toma todo espacio disponible
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (context, i) => _bandTile(bands[i])),
          )
        ],
      ),
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    // 12. Borrar una banda - Dismissible - animacion de elminacion
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      //  onDismissed : se dispara cuando hago todo Movimiento
      onDismissed: (_) => socketService.emit('delete-band', {'id': band.id}),
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
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
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
            title: const Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                  child: const Text('Add'),
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
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }

    // cerrar ese dialogo
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};
    // dataMap.putIfAbsent('Flutter', () => 5);
    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }

    final List<Color> colorList = [
      Colors.blue[50]!,
      Colors.blue[200]!,
      Colors.pink[50]!,
      Colors.pink[200]!,
      Colors.yellow[50]!,
      Colors.yellow[200]!,
    ];

    if (dataMap.isNotEmpty) {
      return Container(
          padding: const EdgeInsets.only(top: 10),
          width: double.infinity,
          height: 200,
          child: PieChart(
            dataMap: dataMap,
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 3.2,
            colorList: colorList,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 32,
            centerText: "HYBRID",
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              // legendShape: _BoxShape.circle,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
            // gradientList: ---To add gradient colors---
            // emptyColorGradient: ---Empty Color gradient---
          ));
    }

    return Container(
      child: const Text('waiting...'),
    );
  }
}

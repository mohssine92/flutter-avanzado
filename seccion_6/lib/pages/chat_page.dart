import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// Models
import 'package:seccion_6/models/mensajes_response.dart';

// Services
import 'package:seccion_6/services/chat_service.dart';
import 'package:seccion_6/services/socket_service.dart';
import 'package:seccion_6/services/auth_service.dart';

// widget
import 'package:seccion_6/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

// para teber this disponible obligatorio la mezcla with TickerProviderStateMixin ver video 67 mas informacion : tema animacion

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  // Controller input
  final _textController = TextEditingController();
  // solucion de problema de perder foco al dar clcik enter en teclado
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  // las intancias de widget responsable de mostracion de mensajes mios y de otra personas en chat
  List<ChatMessage> _messages = [];

  bool _messagesVacia = true;

  // no se puede redibujat nada dentro del initstate - al menos que este dentro de un callback , por eso listen: false
  @override
  void initState() {
    super.initState();

    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    // Inicializacion de Observable - Escuchar mensajes del servidor
    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await chatService.getChat(usuarioID);

    final history = chat.map((m) => ChatMessage(
          texto: m.mensaje,
          uid: m.de, // la persona quien escribio el mensaje
          animationController: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 0))
            ..forward(), // empieza la animacion paraque se muestre
        ));

    setState(() {
      // recuerda - refresh = cierra la app y reabrila la coleccion se vacia de memoria
      // inserte all paraque se les inserta todo ala vez
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    //print('--------------------------Tengo emnsaje : $payload');
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300)),
    );

    // Ya tenemos paylod - hacemos insersacion el la coleccion para poder ver en la pantalal

    setState(() {
      _messages.insert(0, message);
    });

    // para poder ver en pantalla hay que hechar nadar la animacion
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(usuarioPara.nombre.substring(0, 2),
                  style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            const SizedBox(height: 3),
            Text(usuarioPara.nombre,
                style: const TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // necesito widgert sea capaz de expandirse - por eso uso Flexible
            // itemBuilder no acepta _message coleccion vacia da err

            Flexible(
                // Todos mensajes que voy tener - va terminar siendo listView
                child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              // scroll reverso - comprtamiento de scrol de chat - no es como comportamiento de scroll de tarjetas
              reverse: true,
            )),

            const Divider(height: 1),

            // TODO: Espacio de  Caja de texto - escribir - input
            Container(
              color: Colors.white,
              //height: 40, - height automatico depende del contenido de del container hijo
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      // Row implemented - para elenetos uno lado del otro . ene ste casi input alado del button icon
      child: Row(
        children: <Widget>[
          // la caja de texto tiene que expandirse en su totaliada por eso usamos flexible
          Flexible(
              child: TextField(
            controller: _textController,
            autocorrect: false,
            //  onSubmitted - emite texto en tiempo de ejcuccion . accioen poste - click enter
            onSubmitted: _handleSubmit,
            // onChanged - va emitiendo texto texto en tiempo de escritura
            onChanged: (texto) {
              // setState : lo que hace redibuja cuando se muta prop del widget - sabemos depende de una prop mutable de statefulwidget puede ser conficion de acto
              setState(() {
                if (texto.trim().isNotEmpty) {
                  _estaEscribiendo = true;
                } else {
                  _estaEscribiendo = false;
                }
              });
            },
            decoration:
                const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
            focusNode: _focusNode,
          )),

          // Botón de enviar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: const Text('Enviar'),
                    onPressed: _estaEscribiendo
                        ? () => _handleSubmit(_textController.text.trim())
                        : null, // habilitar - desahabiliatr button
                  )
                : Container(
                    // sino : android
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(Icons.send),
                        onPressed: _estaEscribiendo
                            ? () => _handleSubmit(_textController.text.trim())
                            : null, // null  desabillita button
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  // private method - metodo de posteo
  _handleSubmit(String texto) {
    // evitar mandar espaciadoras
    if (texto.trim().length == 0) return;

    // se supene texto se envio - limpiamos input para escribir mas texto
    _textController.clear();

    // Mantener foco en input
    _focusNode.requestFocus();

    // TODO: resolver
    final newMessage = ChatMessage(
      uid: authService.usuario!.uid, // user actualmente connectado en la app
      texto: texto,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    _messagesVacia = false;
    newMessage.animationController.forward();

    // para desagabilitar despues button despues de enviar mensaje  - logica inputa se ha vaciado
    setState(() {
      _estaEscribiendo = false;
    });

    socketService.emit('mensaje-personal', {
      'de': authService
          .usuario?.uid, // es demas porque lo tengo en toekn en server
      'para': chatService.usuarioPara
          .uid, // ventaja de usar service de alto nivel evitar mandar args - entre pantallas
      'mensaje': texto
    });
  }

  // hook - cuando cerramos la pantalla : salimos del widget se dispara
  @override
  void dispose() {
    //TODO:  Limpieza : Off del socket

    for (ChatMessage message in _messages) {
      // Limpieza porque puede que estas instancias  de animacion que estamos haciendo por cada renderizo del widget message nos consuma la memoria .
      message.animationController.dispose();
    }

    // Unsubscribir del Obsevable
    socketService.socket.off('mensaje-personal');

    super.dispose();
  }
}

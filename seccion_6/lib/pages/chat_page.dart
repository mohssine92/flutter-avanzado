import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

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

  // las intancias de widget responsable de mostracion de mensajes mios y de otra persina en chat
  List<ChatMessage> _messages = [];

  bool _messagesVacia = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: const Text('Te', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            const SizedBox(height: 3),
            const Text('Melissa Flores',
                style: TextStyle(color: Colors.black87, fontSize: 12))
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
              print(texto);
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
    //  print(texto.trim().length);

    // evitar mandar espaciadoras
    if (texto.trim().length == 0) return;

    // print( texto );

    // se supene texto se envio - limpiamos input para escribir mas texto
    _textController.clear();

    // Mantener foco en input
    _focusNode.requestFocus();

    // TODO: resolver
    final newMessage = ChatMessage(
      uid: '123',
      texto: texto,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    _messagesVacia = false;
    newMessage.animationController.forward();

    print(_messages);

    // para desagabilitar despues button despues de enviar mensaje  - logica inputa se ha vaciado
    setState(() {
      _estaEscribiendo = false;
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

    super.dispose();
  }
}

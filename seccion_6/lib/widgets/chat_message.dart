import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seccion_6/services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage(
      {
      // Key key,
      required this.texto,
      required this.uid,
      required this.animationController}); //: super(key: key)
  // required de esta manera queda bien claro la informacion requerida para el funcionamiento de un widget

  @override
  Widget build(BuildContext context) {
    // univca Instancia tipo singlton -
    final authService = Provider.of<AuthService>(context, listen: false);
    final myUid = authService.usuario?.uid;
    // FadeTransition : Encargar de hacer animacion de cambio de hopasidad
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          // sirver a mi para mostra un wodget o otro : esta es la idea
          child: uid == myUid ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    // para alinear
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(right: 5, bottom: 5, left: 50),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white),
        ),
        // burbujas de chat
        decoration: BoxDecoration(
            color: const Color(0xff4D9EF6),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(left: 5, bottom: 5, right: 50),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.black87),
        ),
        decoration: BoxDecoration(
            color: const Color(0xffE4E5E8),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

// Importante : saber cual es mi mensaje - cual es mensaje de otra persona - para diferenciar y posicionar

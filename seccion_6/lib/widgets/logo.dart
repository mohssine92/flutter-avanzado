import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String titulo;

  Logo({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          children: <Widget>[
            const Image(image: AssetImage('assets/tag-logo.png')),
            const SizedBox(height: 20),
            Text(titulo, style: const TextStyle(fontSize: 30))
          ],
        ),
      ),
    );
  }
}
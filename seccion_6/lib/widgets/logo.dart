import 'package:flutter/material.dart';

// Utils
import 'package:seccion_6/utils/my_colors.dart';

class Logo extends StatelessWidget {
  final String titulo;
  final String path;
  final double top;

  Logo({required this.titulo, required this.path, required this.top});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        margin: EdgeInsets.only(top: top),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            // const Image(image: AssetImage('assets/tag-logo.png')),
            Image(image: AssetImage(path)),

            SizedBox(height: 20),
            Text(titulo,
                style: TextStyle(
                  fontSize: 20,
                  color: MyColors.primaryColor,
                ))
          ],
        ),
      ),
    );
  }
}

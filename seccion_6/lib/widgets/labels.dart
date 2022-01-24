import 'package:flutter/material.dart';
import 'package:seccion_6/utils/my_colors.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String titulo;
  final String subTitulo;

  const Labels({
    required this.ruta,
    required this.titulo,
    required this.subTitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(titulo,
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w300)),
          //separacion
          const SizedBox(height: 10),
          // GestureDetector : me permiete ami ponerle cualquier gesto y reconocerlo
          GestureDetector(
            child: Text(subTitulo,
                style: TextStyle(
                    // color: Colors.blue[600],
                    color: MyColors.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            onTap: () {
              // navigar a otra pantalla - No puedo proceder porque estoy remplazando pantalla
              Navigator.pushReplacementNamed(context, ruta);
            },
          )
        ],
      ),
    );
  }
}

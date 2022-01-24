import 'package:flutter/material.dart';
import 'package:seccion_6/utils/my_colors.dart';

class DeliveryButtonLogin extends StatelessWidget {
  final String text;
  final dynamic onPressed; // no me funciono la definicion de Funccion

  const DeliveryButtonLogin(
      {
      // Key key,
      required this.text,
      required this.onPressed}); // : super(key: key)

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: onPressed, // ok
        child: Text(text),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryButton,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }
}

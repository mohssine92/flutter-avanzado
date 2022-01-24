import 'package:flutter/material.dart';
import 'package:seccion_6/utils/my_colors.dart';

class DeliveryInput extends StatelessWidget {
  // Definir los args que necesitamos para usar este widget
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  DeliveryInput(
      {
      // Key key,
      required this.icon,
      required this.placeholder,
      required this.textController,
      this.keyboardType = TextInputType.text,
      this.isPassword = false}); // : super(key: key)

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: textController, // extra
        autocorrect: false, // extra
        keyboardType: keyboardType, // extra
        obscureText: isPassword, // extra
        decoration: InputDecoration(
          hintText: placeholder,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: TextStyle(color: MyColors.primaryButton),
          prefixIcon: Icon(
            icon,
            color: MyColors.primaryButton,
          ),
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

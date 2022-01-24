import 'package:flutter/material.dart';
import 'package:seccion_6/utils/my_colors.dart';

class CirclLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        color: MyColors.primaryButton,
      ),
    );
  }
}

// minute_input_field.dart

import 'package:flutter/material.dart';

class MinuteInputField extends StatelessWidget {
  final TextEditingController controller;
  final double fontSize;

  const MinuteInputField(
      {super.key, required this.controller, this.fontSize = 48});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Минимальный размер по горизонтали
      children: [
        SizedBox(
          width: 80, // Ширина для трёх символов
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '0',
            ),
          ),
        ),
        Text(
          ' сек',
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}

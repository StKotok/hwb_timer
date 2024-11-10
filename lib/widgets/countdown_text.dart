// countdown_text.dart

import 'package:flutter/material.dart';

class CountdownText extends StatelessWidget {
  final String text;
  final double fontSize;

  CountdownText({required this.text, this.fontSize = 48});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }
}

import 'package:flutter/material.dart';
class GoogleFontsVariant {
  final FontWeight fontWeight;
  final FontStyle fontStyle;

  GoogleFontsVariant({
    required this.fontWeight,
    required this.fontStyle,
  });

  String toApiFilename() {
    return '${fontWeight.index}_${fontStyle.index}';
  }

  @override
  String toString() {
    return 'w${fontWeight.index}_s${fontStyle.index}';
  }
}

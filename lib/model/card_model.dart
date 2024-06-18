import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

class CardModel {
  // Define una clase llamada `CardModel` que representa un modelo de tarjeta.

  String doctor;
  // Declara una variable `doctor` de tipo `String` para almacenar el nombre del doctor.

  int cardBackground;
  // Declara una variable `cardBackground` de tipo `int` para almacenar el color de fondo de la tarjeta.

  var cardIcon;
  // Declara una variable `cardIcon` de tipo `var` para almacenar el ícono de la tarjeta.

  CardModel(this.doctor, this.cardBackground, this.cardIcon);
  // Define un constructor para la clase `CardModel` que inicializa las variables `doctor`, `cardBackground` y `cardIcon`.
}

List<CardModel> cards = [
  // Declara una lista de `CardModel` llamada `cards` y la inicializa con varias instancias de `CardModel`.

  CardModel("Enfermeria", 0xFFec407a, Icons.local_hospital),
  // Crea una instancia de `CardModel` para Enfermería con un color de fondo específico y un ícono de hospital.

  CardModel("Kinesiologia", 0xFF5c6bc0, Icons.directions_run),
  // Crea una instancia de `CardModel` para Kinesiología con un color de fondo específico y un ícono de correr.

  CardModel("Nutricion", 0xFFfbc02d, Icons.apple),
  // Crea una instancia de `CardModel` para Nutrición con un color de fondo específico y un ícono de manzana.

  CardModel("Psicologia", 0xFF1565C0, Icons.psychology),
  // Crea una instancia de `CardModel` para Psicología con un color de fondo específico y un ícono de psicología.

  CardModel("Medicina General", 0xFF2E7D32, Icons.medical_services),
  // Crea una instancia de `CardModel` para Medicina General con un color de fondo específico y un ícono de servicios médicos.
];

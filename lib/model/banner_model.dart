import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

class BannerModel {
  // Define una clase llamada `BannerModel` que representa un modelo de banner.

  String text;
  // Declara una variable `text` de tipo `String` para almacenar el texto del banner.

  List<Color> cardBackground;
  // Declara una variable `cardBackground` de tipo `List<Color>` para almacenar los colores de fondo del banner.

  String image;
  // Declara una variable `image` de tipo `String` para almacenar la ruta de la imagen del banner.

  BannerModel(this.text, this.cardBackground, this.image);
  // Define un constructor para la clase `BannerModel` que inicializa las variables `text`, `cardBackground` y `image`.
}

List<BannerModel> bannerCards = [
  // Declara una lista de `BannerModel` llamada `bannerCards` y la inicializa con varias instancias de `BannerModel`.

  BannerModel(
      "Sintomas",
      // Texto del banner.

      [
        const Color(0xffa1d4ed),
        const Color(0xffc0eaff),
        // Colores de fondo del banner.
      ],
      "assets/414-bg.png"
      // Ruta de la imagen del banner.
      ),

  BannerModel(
      "Influenza 2024",
      // Texto del banner.

      [
        const Color(0xffb6d4fa),
        const Color(0xffcfe3fc),
        // Colores de fondo del banner.
      ],
      "assets/covid-bg.png"
      // Ruta de la imagen del banner.
      ),
];

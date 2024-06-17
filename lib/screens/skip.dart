import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter para construir la interfaz de usuario.
import 'package:google_fonts/google_fonts.dart'; // Importa el paquete Google Fonts para utilizar fuentes específicas en el texto.
import 'package:introduction_screen/introduction_screen.dart'; // Importa el paquete Introduction Screen para crear pantallas de introducción.

import 'firebase_auth.dart'; // Importa el archivo de autenticación de Firebase para manejar el inicio de sesión y registro.

class Skip extends StatefulWidget {
  // Define un widget de estado llamado Skip.
  const Skip({Key? key}) : super(key: key); // Constructor de la clase Skip.

  @override
  State<Skip> createState() =>
      _SkipState(); // Crea el estado asociado a este widget.
}

class _SkipState extends State<Skip> {
  // Define la clase de estado _SkipState.
  List<PageViewModel> getpages() {
    // Método que retorna una lista de PageViewModel.
    return [
      // Retorna una lista de páginas de introducción.
      PageViewModel(
        title: '', // Título vacío.
        image: Image.asset(
          'assets/medsal.png', // Muestra una imagen ubicada en la carpeta assets.
        ),

        bodyWidget: Column(
          // Widget que contiene el cuerpo de la página.
          mainAxisAlignment: MainAxisAlignment
              .center, // Centra los elementos en el eje principal.
          children: [
            Text(
              'Salud a tu hogar', // Texto principal de la página.
              style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.w900), // Estilo del texto principal.
            ),
            Text(
              'Atención médica personalizada, sin moverte de casa.', // Subtítulo de la página.
              style: GoogleFonts.lato(
                  fontSize: 15,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w800), // Estilo del subtítulo.
            ),
          ],
        ),
      ),
      PageViewModel(
        title: '', // Título vacío.
        image: Image.asset(
          'assets/3.png', // Muestra otra imagen ubicada en la carpeta assets.
        ),

        bodyWidget: Column(
          // Widget que contiene el cuerpo de la página.
          mainAxisAlignment: MainAxisAlignment
              .center, // Centra los elementos en el eje principal.
          children: [
            Text(
              'Tu salud en manos seguras', // Texto principal de la página.
              style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.w900), // Estilo del texto principal.
            ),
            Text(
              'Calidad y confianza a domicilio', // Subtítulo de la página.
              style: GoogleFonts.lato(
                  fontSize: 15,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w800), // Estilo del subtítulo.
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Método build que construye la interfaz de usuario.
    return Scaffold(
      body: IntroductionScreen(
        // Pantalla de introducción principal.
        globalBackgroundColor: Color.fromARGB(
            160, 211, 226, 226), // Color de fondo de la pantalla.
        pages:
            getpages(), // Páginas de introducción obtenidas del método getpages().
        showNextButton: false, // No muestra el botón de siguiente.
        showSkipButton: true, // Muestra el botón de omitir.
        skip: SizedBox(
          // Botón de omitir.
          width: 80, // Ancho del botón.
          height: 48, // Alto del botón.
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20)), // Forma del botón de omitir.
            color: Colors.blue[300], // Color del botón de omitir.
            shadowColor: Colors.blueGrey[100], // Color de la sombra del botón.
            elevation: 5, // Elevación de la sombra del botón.
            child: Center(
              child: Text(
                'Skip', // Texto del botón de omitir.
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    fontSize: 25,
                    fontWeight: FontWeight
                        .w900), // Estilo del texto del botón de omitir.
              ),
            ),
          ),
        ),
        done: SizedBox(
          // Botón de continuar.
          height: 48, // Alto del botón.
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20)), // Forma del botón de continuar.
            color: Colors.blue[300], // Color del botón de continuar.
            shadowColor: Colors.blueGrey[200], // Color de la sombra del botón.
            elevation: 5, // Elevación de la sombra del botón.
            child: Center(
              child: Text(
                'Continuar', // Texto del botón de continuar.
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight
                        .w900), // Estilo del texto del botón de continuar.
              ),
            ),
          ),
        ),
        onDone: () => _pushPage(context,
            const FireBaseAuth()), // Acción al presionar el botón de continuar.
      ),
    );
  }

  // Método para navegar a otra página.
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      // Navega a la nueva página.
      MaterialPageRoute<void>(
          builder: (_) => page), // Define la ruta de la nueva página.
    );
  }
}

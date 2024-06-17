import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter para construir la interfaz de usuario.
import 'package:google_fonts/google_fonts.dart'; // Importa el paquete Google Fonts para utilizar fuentes personalizadas.

import 'register.dart'; // Importa la pantalla de registro.
import 'sign_in.dart'; // Importa la pantalla de inicio de sesión.

class FireBaseAuth extends StatefulWidget {
  // Define un widget con estado llamado FireBaseAuth.
  const FireBaseAuth({Key? key}) : super(key: key); // Constructor del widget.

  @override
  State<FireBaseAuth> createState() =>
      _FireBaseAuthState(); // Crea el estado asociado a este widget.
}

class _FireBaseAuthState extends State<FireBaseAuth> {
  // Define la clase de estado _FireBaseAuthState.
  @override
  Widget build(BuildContext context) {
    // Método build que construye la interfaz de usuario.
    return Scaffold(
      body: Stack(
        // Usa un Stack para superponer widgets.
        children: [
          Container(
            constraints: const BoxConstraints
                .expand(), // Expande el contenedor para llenar todo el espacio disponible.
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/image-medical.png", // Imagen de fondo.
                ),
                fit: BoxFit
                    .cover, // Ajusta la imagen para cubrir todo el contenedor.
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment
                  .topCenter, // Alinea el contenido en el centro superior.
              child: Container(
                alignment: Alignment
                    .topLeft, // Alinea el contenido en la parte superior izquierda.
                padding: const EdgeInsets.only(
                    top: 80.0, left: 25), // Padding del contenedor.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Alinea los hijos en el inicio del eje horizontal.
                  children: [
                    Text(
                      'Hola', // Texto de saludo.
                      style: GoogleFonts.b612(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.w700), // Estilo del texto.
                    ),
                    Text(
                      'Bienvenido a Medsal!', // Texto de bienvenida.
                      style: GoogleFonts.b612(
                          color: Colors.indigo[800],
                          fontSize: 17,
                          fontWeight: FontWeight.w400), // Estilo del texto.
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment
                  .bottomCenter, // Alinea el contenido en el centro inferior.
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .end, // Alinea los hijos al final del eje principal.
                children: [
                  Container(
                    height: 220, // Altura del contenedor.
                    decoration: BoxDecoration(
                      color: Colors.black26
                          .withOpacity(0.25), // Color de fondo con opacidad.
                      borderRadius:
                          BorderRadius.circular(20), // Bordes redondeados.
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Alinea los hijos en el centro horizontalmente.
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Alinea los hijos en el centro verticalmente.
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width /
                              1.1, // Ancho relativo al ancho de la pantalla.
                          padding: const EdgeInsets.all(
                              16), // Padding del contenedor.
                          alignment: Alignment
                              .center, // Alinea el contenido en el centro.
                          child: SizedBox(
                            width: double.infinity, // Ancho completo.
                            height: 50.0, // Altura del botón.
                            child: ElevatedButton(
                              onPressed: () => _pushPage(context,
                                  const SignIn()), // Navega a la pantalla de inicio de sesión.
                              style: ElevatedButton.styleFrom(
                                elevation: 2, // Elevación del botón.
                                backgroundColor: Colors
                                    .indigo[800], // Color de fondo del botón.
                                foregroundColor:
                                    Colors.white, // Color del texto del botón.
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      32.0), // Bordes redondeados.
                                ),
                              ),
                              child: Text(
                                "Iniciar sesión", // Texto del botón.
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight:
                                      FontWeight.bold, // Estilo del texto.
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width /
                              1.1, // Ancho relativo al ancho de la pantalla.
                          padding: const EdgeInsets.all(
                              16), // Padding del contenedor.
                          alignment: Alignment
                              .center, // Alinea el contenido en el centro.
                          child: SizedBox(
                            width: double.infinity, // Ancho completo.
                            height: 50.0, // Altura del botón.
                            child: ElevatedButton(
                              onPressed: () => _pushPage(context,
                                  const Register()), // Navega a la pantalla de registro.
                              style: ElevatedButton.styleFrom(
                                elevation: 2, // Elevación del botón.
                                backgroundColor:
                                    Colors.white, // Color de fondo del botón.
                                foregroundColor:
                                    Colors.black, // Color del texto del botón.
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      32.0), // Bordes redondeados.
                                ),
                              ),
                              child: Text(
                                "Crear Cuenta", // Texto del botón.
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight:
                                      FontWeight.bold, // Estilo del texto.
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 80, // Espaciado vertical.
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pushPage(BuildContext context, Widget page) {
    // Método para navegar a otra página.
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (_) => page), // Define la ruta de la nueva página.
    );
  }
}

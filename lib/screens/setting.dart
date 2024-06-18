import 'package:firebase_auth/firebase_auth.dart';
// Importa la biblioteca de autenticación de Firebase para gestionar la autenticación de usuarios.

import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

import 'package:google_fonts/google_fonts.dart';
// Importa la biblioteca Google Fonts para utilizar fuentes de Google en la aplicación.

import 'package:medsal/firestore_data/user_details.dart';
// Importa el archivo `user_details.dart` del proyecto `medsal`, que probablemente contiene detalles del usuario.

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});
  // Define una clase `UserSettings` que extiende `StatefulWidget`, indicando que este widget puede tener un estado mutable.
  // El constructor `const` se utiliza para crear una instancia constante de esta clase.

  @override
  State<UserSettings> createState() => _UserSettingsState();
  // Sobrescribe el método `createState` para devolver una instancia de `_UserSettingsState`, que manejará el estado de este widget.
}

class _UserSettingsState extends State<UserSettings> {
  UserDetails detail = const UserDetails();
  // Crea una instancia constante de `UserDetails`, que probablemente contiene información del usuario.

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Instancia de `FirebaseAuth` para gestionar la autenticación de usuarios.

  User? user;
  // Variable para almacenar el usuario autenticado actualmente.

  Future<void> _getUser() async {
    user = _auth.currentUser;
    // Método asíncrono para obtener el usuario autenticado actualmente y almacenarlo en la variable `user`.
  }

  Future _signOut() async {
    await _auth.signOut();
    // Método asíncrono para cerrar la sesión del usuario actual.
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    // Sobrescribe el método `initState` para realizar inicializaciones cuando se crea el estado. Llama a `_getUser` para obtener el usuario actual.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        // Establece la elevación de la AppBar.

        backgroundColor: Colors.white,
        // Establece el color de fondo de la AppBar.

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          // Añade un padding de 10 píxeles a la izquierda del botón de retroceso.

          child: IconButton(
            splashRadius: 25,
            // Establece el radio del splash cuando se presiona el botón.

            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.indigo,
              // Establece el icono y su color.
            ),
            onPressed: () => Navigator.of(context).pop(),
            // Navega hacia atrás en la pila de navegación cuando se presiona el botón.
          ),
        ),
        title: Text(
          'Ajustes de usuario',
          style: GoogleFonts.lato(
              color: Colors.indigo, fontSize: 20, fontWeight: FontWeight.bold),
          // Establece el título de la AppBar con estilo utilizando Google Fonts.
        ),
      ),
      body: SingleChildScrollView(
        // Permite que el contenido del cuerpo sea desplazable.

        child: Column(
          children: [
            const UserDetails(),
            // Inserta un widget `UserDetails` constante, que probablemente muestra la información del usuario.

            Container(
              margin: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 30, top: 5),
              // Añade márgenes alrededor del contenedor.

              padding: const EdgeInsets.symmetric(horizontal: 14),
              // Añade padding horizontal dentro del contenedor.

              height: MediaQuery.of(context).size.height / 14,
              // Establece la altura del contenedor como una fracción de la altura total de la pantalla.

              width: MediaQuery.of(context).size.width,
              // Establece el ancho del contenedor para que ocupe todo el ancho de la pantalla.

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // Establece un radio de borde de 10 píxeles.

                color: Colors.red,
                // Establece el color de fondo del contenedor a rojo.
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
                  // Navega a la página de inicio de sesión y elimina todas las rutas anteriores.

                  _signOut();
                  // Llama al método `_signOut` para cerrar la sesión del usuario.
                },
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                // Establece el estilo del botón de texto.

                child: Text(
                  'Desconectar',
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // Establece el estilo del texto del botón usando Google Fonts.
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

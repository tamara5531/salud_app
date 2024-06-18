import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

import 'package:google_fonts/google_fonts.dart';
// Importa la biblioteca Google Fonts para utilizar fuentes de Google en la aplicación.

class NotificationList extends StatefulWidget {
  // Declara una clase `NotificationList` que extiende `StatefulWidget`.
  // Esta clase representa la pantalla de la lista de notificaciones.

  const NotificationList({Key? key}) : super(key: key);
  // Define un constructor constante para `NotificationList` que acepta una clave opcional.

  @override
  State<NotificationList> createState() => _NotificationListState();
  // Sobrescribe el método `createState` para devolver una instancia de `_NotificationListState`,
  // que manejará el estado de este widget.
}

class _NotificationListState extends State<NotificationList> {
  // Define la clase `_NotificationListState` que extiende `State<NotificationList>`
  // para gestionar el estado del widget `NotificationList`.

  @override
  Widget build(BuildContext context) {
    // Sobrescribe el método `build` para construir la interfaz gráfica del widget.

    return Scaffold(
      // Crea un Scaffold para proporcionar una estructura básica a la pantalla.

      appBar: AppBar(
        // Crea una barra de aplicación en la parte superior de la pantalla.

        backgroundColor: Colors.white,
        // Establece el color de fondo de la barra de aplicación a blanco.

        leading: IconButton(
            // Añade un botón de ícono a la izquierda de la barra de aplicación.

            splashRadius: 20,
            // Establece el radio de salpicadura del botón a 20.

            icon: const Icon(
              Icons.arrow_back_ios,
              // Establece el ícono del botón a una flecha hacia atrás.

              color: Colors.indigo,
              // Establece el color del ícono a índigo.
            ),
            onPressed: () {
              Navigator.pop(context);
              // Define la acción al presionar el botón: navega de regreso a la pantalla anterior.
            }),

        title: Text(
          'Notificaciones',
          // Establece el título de la barra de aplicación a "Notificaciones".

          style: GoogleFonts.lato(
            // Aplica el estilo del texto usando la fuente Lato.

            color: Colors.indigo,
            // Establece el color del texto a índigo.

            fontSize: 18,
            // Establece el tamaño de la fuente a 18.

            fontWeight: FontWeight.bold,
            // Establece el peso de la fuente a negrita.
          ),
        ),
      ),
    );
  }
}

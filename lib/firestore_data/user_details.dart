import 'dart:math'; // Importa la biblioteca 'math' de Dart para el uso de funciones matemáticas.

import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore de Firebase.
import 'package:firebase_auth/firebase_auth.dart'; // Importa la autenticación de Firebase.
import 'package:flutter/material.dart'; // Importa Flutter para la creación de interfaces de usuario.
import 'package:google_fonts/google_fonts.dart'; // Importa Google Fonts para el uso de fuentes personalizadas.
import 'package:medsal/globals.dart'; // Importa un archivo de variables globales (asumiendo que existe en tu proyecto).
import 'package:medsal/model/update_user_details.dart'; // Importa una pantalla para actualizar los detalles del usuario.

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final FirebaseAuth _auth = FirebaseAuth
      .instance; // Obtiene una instancia de autenticación de Firebase.
  late User user; // Declara una variable para el usuario autenticado.

  // Mapa para almacenar los detalles del usuario.
  Map<String, dynamic> details = {};

  // Función para obtener los detalles del usuario desde Firestore.
  Future<void> _getUser() async {
    user = _auth.currentUser!; // Obtiene el usuario actual.

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection(isDoctor
            ? 'doctor'
            : 'patient') // Selecciona la colección dependiendo si es doctor o paciente.
        .doc(user.uid)
        .get(); // Obtiene el documento del usuario.

    setState(() {
      details = snap.data() as Map<String,
          dynamic>; // Almacena los datos del usuario en el mapa 'details'.
    });
    debugPrint(snap.data()
        as String?); // Imprime los datos del usuario para depuración.
  }

  @override
  void initState() {
    super.initState();
    _getUser(); // Llama a la función para obtener los detalles del usuario cuando se inicializa el estado.
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
        controller:
            ScrollController(), // Controlador para el desplazamiento de la lista.
        shrinkWrap: true,
        itemCount: details
            .length, // Número de elementos en la lista basado en el tamaño del mapa 'details'.
        itemBuilder: (context, index) {
          String key = details.keys
              .elementAt(index); // Obtiene la clave en la posición actual.
          String value = details[key] == null
              ? 'No añadido'
              : details[key]
                  .toString(); // Obtiene el valor correspondiente o 'No añadido' si es nulo.
          String label = key[0].toUpperCase() +
              key.substring(
                  1); // Capitaliza la primera letra de la clave para usarla como etiqueta.

          return Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5), // Margen del contenedor.
            child: InkWell(
              splashColor: Colors.grey
                  .withOpacity(0.5), // Color de salpicadura al hacer clic.
              borderRadius:
                  BorderRadius.circular(10), // Radio de borde redondeado.
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateUserDetails(
                      label: label,
                      field: key,
                      value: value,
                    ),
                  ),
                ).then((value) {
                  // Recarga la página después de regresar de la pantalla de actualización.
                  _getUser();
                  setState(() {});
                });
              },
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10), // Radio de borde redondeado.
                  color: Colors.grey[200], // Color de fondo del contenedor.
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14), // Relleno interno del contenedor.
                  height: MediaQuery.of(context).size.height /
                      14, // Altura del contenedor.
                  width: MediaQuery.of(context)
                      .size
                      .width, // Ancho del contenedor.
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Distribuye los hijos del contenedor de manera equitativa.
                    children: [
                      Text(
                        label, // Muestra la etiqueta.
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        value.substring(
                            0,
                            min(
                                20,
                                value
                                    .length)), // Muestra el valor, truncado a 20 caracteres si es necesario.
                        style: GoogleFonts.lato(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

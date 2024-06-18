import 'package:cloud_firestore/cloud_firestore.dart';
// Importa la biblioteca de Cloud Firestore para interactuar con la base de datos Firestore.

import 'package:firebase_auth/firebase_auth.dart';
// Importa la biblioteca de autenticación de Firebase para manejar la autenticación de usuarios.

import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

import 'package:google_fonts/google_fonts.dart';
// Importa la biblioteca Google Fonts para utilizar fuentes de Google en la aplicación.

import 'package:medsal/globals.dart';
// Importa un archivo local llamado globals.dart, que probablemente contiene variables globales para la aplicación.

import 'package:intl/intl.dart';
// Importa la biblioteca intl para la manipulación y formateo de fechas y horas.

class AppointmentHistoryList extends StatefulWidget {
  // Declara una clase `AppointmentHistoryList` que extiende `StatefulWidget`.
  // Esta clase representa la pantalla del historial de citas.

  const AppointmentHistoryList({Key? key}) : super(key: key);
  // Define un constructor constante para `AppointmentHistoryList` que acepta una clave opcional.

  @override
  State<AppointmentHistoryList> createState() => _AppointmentHistoryListState();
  // Sobrescribe el método `createState` para devolver una instancia de `_AppointmentHistoryListState`,
  // que manejará el estado de este widget.
}

class _AppointmentHistoryListState extends State<AppointmentHistoryList> {
  // Define la clase `_AppointmentHistoryListState` que extiende `State<AppointmentHistoryList>`
  // para gestionar el estado del widget `AppointmentHistoryList`.

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Crea una instancia de `FirebaseAuth` para manejar la autenticación de usuarios.

  late User user;
  // Declara una variable `user` de tipo `User` que se inicializará más tarde.

  // ignore: unused_field
  late String _documentID;
  // Declara una variable `_documentID` de tipo `String` que se inicializará más tarde.

  Future<void> _getUser() async {
    // Método para obtener el usuario autenticado actual.
    user = _auth.currentUser!;
    // Asigna el usuario autenticado actual a la variable `user`.
  }

  // Método para formatear la fecha a un formato más legible.
  String _dateFormatter(String timestamp) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(timestamp));
    // Formatea la fecha en el formato 'dd-MM-yyyy'.

    return formattedDate;
    // Devuelve la fecha formateada.
  }

  // Método para eliminar una cita del historial de citas.
  Future<void> deleteAppointment(String docID) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.uid)
        .collection('all')
        .doc(docID)
        .delete();
    // Elimina la cita de la colección de todas las citas del usuario.
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    // Llama al método `_getUser` cuando se inicializa el estado.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Crea un widget `SafeArea` para evitar que el contenido se superponga con las áreas del sistema operativo.

        child: StreamBuilder(
          // Crea un `StreamBuilder` para escuchar cambios en los datos de Firestore.

          stream: FirebaseFirestore.instance
              .collection('appointments')
              .doc(user.uid)
              .collection('all')
              .orderBy('date', descending: true)
              .snapshots(),
          // Escucha los cambios en la colección de todas las citas del usuario autenticado,
          // ordenadas por fecha en orden descendente.

          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
                // Muestra un indicador de progreso mientras se cargan los datos.
              );
            }
            return snapshot.data!.size == 0
                ? Text(
                    'El historial aparece aquí...',
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  )
                // Muestra un mensaje si no hay citas en el historial.

                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      // Obtiene el documento en el índice actual.

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            height: 70,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blueGrey[50],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nombre del doctor o paciente
                                Text(
                                  '${index + 1}. ${isDoctor ? '${document['patientName']}' : '${document['doctorName']}'}',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                  ),
                                ),
                                // Fecha de la cita
                                Text(
                                  _dateFormatter(
                                      document['date'].toDate().toString()),
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                // Razón o descripción de la cita
                                Text(
                                    document['description'] ?? 'No description')
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                            // Añade un espacio vertical de 10 píxeles.
                          ),
                        ],
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}

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

class AppointmentList extends StatefulWidget {
  // Declara una clase `AppointmentList` que extiende `StatefulWidget`.
  // Esta clase representa la pantalla de la lista de citas.

  const AppointmentList({Key? key}) : super(key: key);
  // Define un constructor constante para `AppointmentList` que acepta una clave opcional.

  @override
  State<AppointmentList> createState() => _AppointmentListState();
  // Sobrescribe el método `createState` para devolver una instancia de `_AppointmentListState`,
  // que manejará el estado de este widget.
}

class _AppointmentListState extends State<AppointmentList> {
  // Define la clase `_AppointmentListState` que extiende `State<AppointmentList>`
  // para gestionar el estado del widget `AppointmentList`.

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Crea una instancia de `FirebaseAuth` para manejar la autenticación de usuarios.

  late User user;
  // Declara una variable `user` de tipo `User` que se inicializará más tarde.

  late String _documentID;
  // Declara una variable `_documentID` de tipo `String` que se inicializará más tarde.

  Future<void> _getUser() async {
    // Método para obtener el usuario autenticado actual.
    user = _auth.currentUser!;
    // Asigna el usuario autenticado actual a la variable `user`.
  }

  // Método para eliminar una cita tanto del paciente como del doctor.
  Future<void> deleteAppointment(
      String docID, String doctorId, String patientId) async {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(doctorId)
        .collection('pending')
        .doc(docID)
        .delete();
    // Elimina la cita de la colección de citas pendientes del doctor.

    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(patientId)
        .collection('pending')
        .doc(docID)
        .delete();
    // Elimina la cita de la colección de citas pendientes del paciente.
  }

  // Método para formatear la fecha a un formato más legible.
  String _dateFormatter(String timestamp) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(timestamp));
    // Formatea la fecha en el formato 'dd-MM-yyyy'.

    return formattedDate;
    // Devuelve la fecha formateada.
  }

  // Método para formatear la hora a un formato más legible.
  String _timeFormatter(String timestamp) {
    String formattedTime =
        DateFormat('kk:mm').format(DateTime.parse(timestamp));
    // Formatea la hora en el formato 'kk:mm'.

    return formattedTime;
    // Devuelve la hora formateada.
  }

  // Método para mostrar un cuadro de diálogo de confirmación para eliminar una cita.
  showAlertDialog(BuildContext context, String doctorId, String patientId) {
    // Botón de cancelación.
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
        // Cierra el cuadro de diálogo.
      },
    );

    // Botón de confirmación.
    Widget continueButton = TextButton(
      child: const Text("Si"),
      onPressed: () {
        deleteAppointment(_documentID, doctorId, patientId);
        // Llama al método `deleteAppointment` para eliminar la cita.
        Navigator.of(context).pop();
        // Cierra el cuadro de diálogo.
      },
    );

    // Configura el AlertDialog.
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmar eliminación"),
      content: const Text("¿Está seguro de que desea eliminar esta cita?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // Muestra el cuadro de diálogo.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Método para ayudar a eliminar las citas pendientes.
  _checkDiff(DateTime date) {
    debugPrint(date as String?);
    // Imprime la fecha en la consola para fines de depuración.

    var diff = DateTime.now().difference(date).inSeconds;
    // Calcula la diferencia en segundos entre la fecha actual y la fecha dada.

    debugPrint('diferencia de fecha : $diff');
    // Imprime la diferencia de fecha en la consola para fines de depuración.

    if (diff > 0) {
      return true;
      // Devuelve `true` si la diferencia es mayor que 0 (la fecha está en el pasado).
    } else {
      return false;
      // Devuelve `false` si la diferencia es 0 o menor (la fecha está en el futuro).
    }
  }

  // Método para comparar fechas.
  _compareDate(String date) {
    if (_dateFormatter(DateTime.now().toString())
            .compareTo(_dateFormatter(date)) ==
        0) {
      return true;
      // Devuelve `true` si la fecha actual es igual a la fecha dada.
    } else {
      return false;
      // Devuelve `false` si la fecha actual no es igual a la fecha dada.
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    // Llama al método `_getUser` cuando se inicializa el estado.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Crea un widget `SafeArea` para evitar que el contenido se superponga con las áreas del sistema operativo.

      child: StreamBuilder(
        // Crea un `StreamBuilder` para escuchar cambios en los datos de Firestore.

        stream: FirebaseFirestore.instance
            .collection('appointments')
            .doc(user.uid)
            .collection('pending')
            .orderBy('date')
            .snapshots(),
        // Escucha los cambios en la colección de citas pendientes del usuario autenticado,
        // ordenadas por fecha.

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
              // Muestra un indicador de progreso mientras se cargan los datos.
            );
          }
          return snapshot.data!.size == 0
              ? Center(
                  child: Text(
                    'No hay cita programada',
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                )
              // Muestra un mensaje si no hay citas programadas.

              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    // Obtiene el documento en el índice actual.

                    // Elimina las citas pasadas de la lista de citas pendientes.
                    if (_checkDiff(document['date'].toDate())) {
                      deleteAppointment(document.id, document['doctorId'],
                          document['patientId']);
                    }

                    // Cada cita.
                    return Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: () {},
                        child: ExpansionTile(
                          initiallyExpanded: true,

                          // Información principal de la cita.
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Nombre del doctor o paciente.
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  isDoctor
                                      ? document['patientName']
                                      : document['doctorName'],
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // Etiqueta "HOY".
                              Text(
                                _compareDate(
                                        document['date'].toDate().toString())
                                    ? "HOY"
                                    : "",
                                style: GoogleFonts.lato(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(
                                width: 0,
                              ),
                            ],
                          ),

                          // Fecha de la cita.
                          subtitle: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              _dateFormatter(
                                  document['date'].toDate().toString()),
                              style: GoogleFonts.lato(),
                            ),
                          ),

                          // Información del paciente.
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20, right: 10, left: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Información del paciente.
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Nombre del paciente.
                                      Text(
                                        isDoctor
                                            ? ''
                                            : "Nombre paciente: ${document['patientName']}",
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      // Hora de la cita.
                                      Text(
                                        'Horario: ${_timeFormatter(document['date'].toDate().toString())}',
                                        style: GoogleFonts.lato(fontSize: 16),
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),

                                      // Descripción de la cita.
                                      Text(
                                        'Descripcion : ${document['description']}',
                                        style: GoogleFonts.lato(fontSize: 16),
                                      )
                                    ],
                                  ),

                                  // Botón para eliminar la cita.
                                  IconButton(
                                    tooltip: 'Eliminar cita',
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _documentID = document.id;
                                      showAlertDialog(
                                          context,
                                          document['doctorId'],
                                          document['patientId']);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}

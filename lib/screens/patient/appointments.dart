import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter para el desarrollo de aplicaciones.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos en la nube.
import 'package:intl/intl.dart'; // Importa el paquete intl para dar formato a las fechas y horas.
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Authentication para manejar la autenticación del usuario.

class Appointments extends StatelessWidget {
  // Define un widget sin estado llamado Appointments.
  const Appointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth =
        FirebaseAuth.instance; // Obtiene la instancia de FirebaseAuth.
    final User? user =
        _auth.currentUser; // Obtiene el usuario actual autenticado.

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Mis Citas'), // Define el título de la barra de la aplicación.
      ),
      body: user == null
          ? const Center(
              child: Text(
                  'Ningún usuario ha iniciado sesión')) // Muestra un mensaje si no hay usuario autenticado.
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(
                      'appointments') // Accede a la colección 'appointments' en Firestore.
                  .doc(user
                      .uid) // Usa el ID del usuario actual para obtener sus citas.
                  .collection(
                      'all') // Accede a la subcolección 'all' dentro del documento del usuario.
                  .snapshots(), // Escucha los cambios en tiempo real en los documentos de esta subcolección.
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(), // Muestra un indicador de carga mientras se obtienen los datos.
                  );
                }

                var appointments = snapshot.data!
                    .docs; // Obtiene la lista de documentos (citas) del snapshot.
                if (appointments.isEmpty) {
                  return const Center(
                    child: Text(
                        'No se encontraron citas'), // Muestra un mensaje si no se encontraron citas.
                  );
                }

                return ListView.builder(
                  itemCount: appointments
                      .length, // Define la cantidad de elementos en la lista.
                  itemBuilder: (context, index) {
                    var appointment = appointments[
                        index]; // Obtiene la cita en la posición actual del índice.

                    // Convertir el Timestamp a DateTime
                    Timestamp timestamp =
                        appointment['date']; // Obtiene el Timestamp de la cita.
                    DateTime date = timestamp
                        .toDate(); // Convierte el Timestamp a DateTime.

                    return ListTile(
                      title: Text(appointment[
                          'doctorName']), // Muestra el nombre del doctor como título.
                      subtitle: Text(DateFormat('dd-MM-yyyy HH:mm').format(
                          date)), // Muestra la fecha y hora formateada como subtítulo.
                    );
                  },
                );
              },
            ),
    );
  }
}

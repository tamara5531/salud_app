import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

import 'package:cloud_firestore/cloud_firestore.dart';
// Importa la biblioteca de Cloud Firestore para interactuar con la base de datos Firestore.

import 'package:firebase_auth/firebase_auth.dart';
// Importa la biblioteca de Firebase Auth para manejar la autenticación de usuarios.

class DoctorSpecialization extends StatefulWidget {
  @override
  _DoctorSpecializationState createState() => _DoctorSpecializationState();
  // Define el método `createState` que devuelve una instancia de `_DoctorSpecializationState`.
}

class _DoctorSpecializationState extends State<DoctorSpecialization> {
  // Define la clase `_DoctorSpecializationState` que extiende `State<DoctorSpecialization>` para gestionar el estado del widget.

  late String _selectedSpecialization;
  // Declara una variable para almacenar la especialización seleccionada.

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Crea una instancia de FirebaseAuth para manejar la autenticación.

  @override
  Widget build(BuildContext context) {
    // Sobrescribe el método `build` para construir la interfaz de usuario.

    return Scaffold(
      // Utiliza un Scaffold para la estructura básica de la pantalla.

      appBar: AppBar(
        title: Text('Selecciona el Profesional'),
        // Establece el título de la AppBar.
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Utiliza un StreamBuilder para escuchar cambios en la colección 'specializations' de Firestore.

        stream: FirebaseFirestore.instance
            .collection('specializations')
            .snapshots(),
        // Define el stream que escucha los cambios en la colección 'specializations'.

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
            // Muestra un indicador de progreso mientras se cargan los datos.
          }

          var specializations = snapshot.data!.docs;
          // Almacena los documentos de la colección 'specializations'.

          return ListView.builder(
            // Construye una lista utilizando ListView.builder.

            itemCount: specializations.length,
            // Define el número de elementos en la lista basado en el número de documentos.

            itemBuilder: (context, index) {
              var specialization = specializations[index];
              // Obtiene el documento de especialización en el índice actual.

              return ListTile(
                // Crea un ListTile para cada especialización.

                title: Text(specialization['name']),
                // Establece el nombre de la especialización como título del ListTile.

                onTap: () async {
                  // Define la acción que se ejecuta al tocar el ListTile.

                  setState(() {
                    _selectedSpecialization = specialization['name'];
                    // Actualiza la especialización seleccionada.
                  });

                  User? user = _auth.currentUser;
                  // Obtiene el usuario actual.

                  // Guarda la especialización seleccionada en el documento del doctor en Firestore.
                  await FirebaseFirestore.instance
                      .collection('doctors')
                      .doc(user?.uid)
                      .set({
                    'specialization': _selectedSpecialization,
                  }, SetOptions(merge: true));
                },
              );
            },
          );
        },
      ),
    );
  }
}

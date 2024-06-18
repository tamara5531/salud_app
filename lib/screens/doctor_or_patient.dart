import 'package:cloud_firestore/cloud_firestore.dart';
// Importa la biblioteca de Cloud Firestore para interactuar con la base de datos Firestore.

import 'package:firebase_auth/firebase_auth.dart';
// Importa la biblioteca de autenticación de Firebase para gestionar la autenticación de usuarios.

import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

import 'package:medsal/globals.dart';
// Importa el archivo `globals.dart` del proyecto `medsal`, donde probablemente se encuentran definidas variables globales.

import 'package:medsal/screens/doctor/main_page_doctor.dart';
// Importa el archivo `main_page_doctor.dart` del proyecto `medsal`, que probablemente contiene la pantalla principal para los doctores.

import 'package:medsal/screens/patient/main_page_patient.dart';
// Importa el archivo `main_page_patient.dart` del proyecto `medsal`, que probablemente contiene la pantalla principal para los pacientes.

class DoctorOrPatient extends StatefulWidget {
  const DoctorOrPatient({Key? key}) : super(key: key);
  // Define la clase `DoctorOrPatient` que extiende `StatefulWidget`, indicando que este widget puede tener un estado mutable.
  // El constructor `const` se utiliza para crear una instancia constante de esta clase.

  @override
  State<DoctorOrPatient> createState() => _DoctorOrPatientState();
  // Sobrescribe el método `createState` para devolver una instancia de `_DoctorOrPatientState`, que manejará el estado de este widget.
}

class _DoctorOrPatientState extends State<DoctorOrPatient> {
  bool _isLoading = true;
  // Variable para indicar si la información está cargando.

  void _setUser() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      // Obtiene el usuario autenticado actualmente.

      if (user != null) {
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        // Obtiene el documento del usuario desde Firestore.

        if (snap.exists) {
          var basicInfo = snap.data() as Map<String, dynamic>?;
          // Convierte los datos del documento en un mapa.

          if (basicInfo != null) {
            isDoctor = basicInfo['type'] == 'Profesional';
            // Actualiza la variable global `isDoctor` según el tipo de usuario.

            print('isDoctor : $isDoctor');
          } else {
            print('No se encontraron datos en el documento del usuario');
          }
        } else {
          print('El documento de usuario no existe');
        }
      } else {
        print('No se encontró ningún usuario actual');
      }
    } catch (e) {
      print('No se pudo establecer el usuario: $e');
      // Maneja las excepciones y muestra el error en la consola.
    } finally {
      setState(() {
        _isLoading = false;
        // Detiene la carga en el estado del widget.
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setUser();
    // Llama a `_setUser` para obtener la información del usuario cuando se inicializa el estado del widget.
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        // Muestra un indicador de progreso mientras se carga la información.

        : isDoctor
            ? const MainPageDoctor()
            // Muestra la pantalla principal para los doctores si el usuario es un profesional.

            : const MainPagePatient();
    // Muestra la pantalla principal para los pacientes si el usuario no es un profesional.
  }
}

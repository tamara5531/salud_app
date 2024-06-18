import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter para el desarrollo de aplicaciones.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Cloud Firestore para manejar la base de datos en la nube.
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para manejar la autenticación de usuarios.
import 'doctor_specialization.dart'; // Importa la pantalla de especialización del doctor.

class DoctorSettings extends StatefulWidget {
  // Define un widget con estado llamado DoctorSettings.
  @override
  _DoctorSettingsState createState() =>
      _DoctorSettingsState(); // Crea el estado para el widget.
}

class _DoctorSettingsState extends State<DoctorSettings> {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Obtiene una instancia de FirebaseAuth.
  User? user; // Define una variable para almacenar el usuario actual.
  String?
      _currentSpecialization; // Define una variable para almacenar la especialización actual del doctor.

  @override
  void initState() {
    // Se llama una vez al crear el estado del widget.
    super.initState();
    _getCurrentUser(); // Llama a la función para obtener el usuario actual.
  }

  void _getCurrentUser() async {
    // Función para obtener el usuario actual y su especialización desde Firestore.
    user = _auth.currentUser; // Obtiene el usuario actual.
    if (user != null) {
      // Si hay un usuario autenticado,
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(user!.uid)
          .get(); // Obtiene el documento del doctor desde Firestore.
      setState(() {
        _currentSpecialization = doc[
            'specialization']; // Actualiza la especialización actual en el estado.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construye la interfaz de usuario del widget.
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Configuración del profesional'), // Título de la barra de aplicaciones.
      ),
      body: Padding(
        // Añade un relleno alrededor del contenido.
        padding: EdgeInsets.all(16.0),
        child: Column(
          // Organiza los widgets en una columna.
          crossAxisAlignment: CrossAxisAlignment
              .start, // Alinea los hijos al inicio en el eje transversal.
          children: <Widget>[
            Text(
                'Especialización actual: $_currentSpecialization'), // Muestra la especialización actual del doctor.
            SizedBox(height: 20), // Añade un espacio entre los widgets.
            ElevatedButton(
              onPressed: () {
                // Función que se ejecuta al presionar el botón.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorSpecialization()),
                ).then((_) {
                  // Refresca la especialización después de regresar de la pantalla de selección.
                  _getCurrentUser();
                });
              },
              child: Text('Seleccionar Especialización'), // Texto del botón.
            ),
          ],
        ),
      ),
    );
  }
}

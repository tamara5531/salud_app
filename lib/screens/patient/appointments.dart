import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Appointments extends StatelessWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Citas'),
      ),
      body: user == null
          ? const Center(
              child: Text('Ningún usuario ha iniciado sesión'),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .doc(user.uid)
                  .collection('all')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var appointments = snapshot.data!.docs;
                if (appointments.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron citas'),
                  );
                }

                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    var appointment = appointments[index];

                    // Convertir el Timestamp a DateTime
                    Timestamp timestamp = appointment['fecha']; // Utiliza el campo 'fecha' en lugar de 'date'
                    DateTime date = timestamp.toDate();

                    return ListTile(
                      title: Text(appointment['nombreProfesional'] ?? 'No Name'),
                      subtitle: Text(
                        DateFormat('dd-MM-yyyy HH:mm').format(date),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

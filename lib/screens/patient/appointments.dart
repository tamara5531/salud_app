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
        title: const Text('My Appointments'),
      ),
      body: user == null
          ? const Center(child: Text('No user is logged in'))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .doc(user!.uid) // Usar el ID del usuario actual
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
                    child: Text('No appointments found'),
                  );
                }
                
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    var appointment = appointments[index];

                    // Convertir el Timestamp a DateTime
                    Timestamp timestamp = appointment['date'];
                    DateTime date = timestamp.toDate();

                    return ListTile(
                      title: Text(appointment['doctorName']),
                      subtitle: Text(DateFormat('dd-MM-yyyy HH:mm').format(date)),
                    );
                  },
                );
              },
            ),
    );
  }
}


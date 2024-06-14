import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorSpecialization extends StatefulWidget {
  @override
  _DoctorSpecializationState createState() => _DoctorSpecializationState();
}

class _DoctorSpecializationState extends State<DoctorSpecialization> {
  late String _selectedSpecialization;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Specialization'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('specializations').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var specializations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: specializations.length,
            itemBuilder: (context, index) {
              var specialization = specializations[index];
              return ListTile(
                title: Text(specialization['name']),
                onTap: () async {
                  setState(() {
                    _selectedSpecialization = specialization['name'];
                  });
                  User? user = _auth.currentUser;
                  // Aquí guardamos la especialización en el documento del doctor
                  await FirebaseFirestore.instance.collection('doctors').doc(user?.uid).set({
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

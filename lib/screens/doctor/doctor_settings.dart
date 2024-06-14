import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'doctor_specialization.dart'; // Importar la pantalla de especialización

class DoctorSettings extends StatefulWidget {
  @override
  _DoctorSettingsState createState() => _DoctorSettingsState();
}

class _DoctorSettingsState extends State<DoctorSettings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? _currentSpecialization;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('doctors').doc(user!.uid).get();
      setState(() {
        _currentSpecialization = doc['specialization'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Current Specialization: $_currentSpecialization'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorSpecialization()),
                ).then((_) {
                  // Refresh after returning from the selection screen
                  _getCurrentUser();
                });
              },
              child: Text('Select Specialization'),
            ),
          ],
        ),
      ),
    );
  }
}

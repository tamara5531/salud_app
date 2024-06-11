import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medsal/globals.dart';
import 'package:medsal/screens/doctor/main_page_doctor.dart';
import 'package:medsal/screens/patient/main_page_patient.dart';

class DoctorOrPatient extends StatefulWidget {
  const DoctorOrPatient({Key? key}) : super(key: key);

  @override
  State<DoctorOrPatient> createState() => _DoctorOrPatientState();
}

class _DoctorOrPatientState extends State<DoctorOrPatient> {
  bool _isLoading = true;

  void _setUser() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (snap.exists) {
          var basicInfo = snap.data() as Map<String, dynamic>?;

          if (basicInfo != null) {
            isDoctor = basicInfo['type'] == 'doctor';
            print('isDoctor : $isDoctor');
          } else {
            print('No data found in user document');
          }
        } else {
          print('User document does not exist');
        }
      } else {
        print('No current user found');
      }
    } catch (e) {
      print('Failed to set user: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setUser();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : isDoctor
            ? const MainPageDoctor()
            : const MainPagePatient();
  }
}

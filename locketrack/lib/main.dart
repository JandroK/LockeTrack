import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:locketrack/auth/auth_gate.dart';
import 'package:locketrack/auth/auth_service.dart';
import 'package:locketrack/screens/select_region.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AuthGate(app: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User user = authService.value.firebaseAuth.currentUser!;
    var db = FirebaseFirestore.instance.collection("users");
    db.doc(user.uid).set({'name': user.email});
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.amber),
      home: RegionNameMap(db: db.doc(user.uid)),
    );
  }
}

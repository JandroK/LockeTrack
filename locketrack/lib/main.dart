import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return MaterialApp(
      home: Scaffold(
        body: StreamBuilder(
          stream: db.doc("/rutas/UiPJT7UsajX2HdSW5AEP").snapshots(),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
          ) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final doc = snapshot.data!.data();
            if (doc != null) {
              return Center(child: Text(doc['nombre']));
            } else {
              return const Center(child: Text("doc is null!"));
            }
          },
        ),
      ),
    );
  }
}

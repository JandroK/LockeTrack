import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RuteScreen extends StatelessWidget {
  RuteScreen({
    Key? key,
  }) : super(key: key);

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

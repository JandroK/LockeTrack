import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locketrack/screens/list_pokemon.dart';

class CoachToken extends StatefulWidget {
  final String docID;
  const CoachToken({
    required this.docID,
    Key? key,
  }) : super(key: key);

  @override
  State<CoachToken> createState() => _CoachTokenState();
}

class _CoachTokenState extends State<CoachToken> {
  late DocumentReference<Map<String, dynamic>> db;
  List<String> medals = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance.collection("regions").doc(widget.docID);
    loadMedals();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void loadMedals() async {
    await db.collection("medals").orderBy("index").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        medals.add(result.id);
      });
    });
    setState(() {
      print("Ya he cargado los path");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokémon Rojo Fuego"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              for (int i = 0; i < medals.length; i++)
                Expanded(
                  child: MedalSnapshot(db: db, path: medals[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class MedalSnapshot extends StatelessWidget {
  final String path;
  const MedalSnapshot({
    required this.path,
    required this.db,
    Key? key,
  }) : super(key: key);

  final DocumentReference<Map<String, dynamic>> db;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.collection("medals").doc(path).snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final doc = snapshot.data!.data();
        if (doc != null) {
          return Image(
            image: AssetImage("assets/" + doc["image"]),
          );
        } else {
          return const Center(child: Text("doc is null!"));
        }
      },
    );
  }
}

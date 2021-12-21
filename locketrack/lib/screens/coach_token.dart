import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locketrack/screens/list_pokemon.dart';

class CoachToken extends StatefulWidget {
  final String docID;
  final List<String> medalsList;
  const CoachToken({
    required this.docID,
    required this.medalsList,
    Key? key,
  }) : super(key: key);

  @override
  State<CoachToken> createState() => _CoachTokenState();
}

class _CoachTokenState extends State<CoachToken> {
  late DocumentReference<Map<String, dynamic>> db;
  late int lives = 10;
  late int medalCount = 0;
  List<String> medals = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance.collection("regions").doc(widget.docID);
    generateMedals(db.collection("medals"), widget.medalsList, widget.docID);
    getCoachInfo(db);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void generateMedals(CollectionReference<Map<String, dynamic>> collection,
      List<String> medalName, String path) {
    collection.get().then((value) {
      if (value.size == 0) {
        int i = 1;
        medalName.forEach((element) async {
          await collection.add({
            'name': element,
            'index': i++,
          });
        });
      }
    }).then((value) => loadMedals());
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

  void getCoachInfo(DocumentReference<Map<String, dynamic>> doc) async {
    await doc.get().then((value) => lives = value.data()?["lives"]);
    await doc.get().then((value) => medalCount = value.data()?["medals"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Locke Progression"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              for (int i = 0; i < medals.length / 2; i++)
                Expanded(
                  child: MedalSnapshot(
                    db: db,
                    path: medals[i],
                    index: i,
                    medalCount: medalCount,
                  ),
                ),
            ],
          ),
          Row(
            children: [
              for (int i = 4; i < medals.length; i++)
                Expanded(
                  child: MedalSnapshot(
                      db: db,
                      path: medals[i],
                      index: i,
                      medalCount: medalCount),
                ),
            ],
          ),
          Row(
            children: [
              for (int i = 0; i < 5; i++)
                Expanded(
                  child: (i > lives - 1)
                      ? const ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Colors.black38, BlendMode.modulate),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image(
                              image: AssetImage("assets/heart.png"),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Image(
                            image: AssetImage("assets/heart.png"),
                          ),
                        ),
                ),
            ],
          ),
          Row(
            children: [
              for (int i = 5; i < 10; i++)
                Expanded(
                  child: (i > lives - 1)
                      ? const ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Colors.black38, BlendMode.modulate),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image(
                              image: AssetImage("assets/heart.png"),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Image(
                            image: AssetImage("assets/heart.png"),
                          ),
                        ),
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
  final int index;
  final int medalCount;
  const MedalSnapshot({
    required this.path,
    required this.index,
    required this.medalCount,
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
          return (index > medalCount - 1)
              ? ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(Colors.black38, BlendMode.modulate),
                  child: Image(
                    image: AssetImage("assets/medals/" + doc["name"] + ".png"),
                  ),
                )
              : Image(
                  image: AssetImage("assets/medals/" + doc["name"] + ".png"),
                );
        } else {
          return const Center(child: Text("doc is null!"));
        }
      },
    );
  }
}

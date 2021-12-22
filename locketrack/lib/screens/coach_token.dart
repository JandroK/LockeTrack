import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locketrack/screens/list_pokemon.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';

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
          MedalRow(0, medals.length ~/ 2),
          MedalRow(medals.length ~/ 2, medals.length),
          LiveRow(0, 5),
          LiveRow(5, 10),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Row LiveRow(int init, int length) {
    return Row(
      children: [
        for (int i = init; i < length; i++)
          Expanded(
              child: HeartSnapshot(
            db: db,
            index: i,
            lives: lives,
            onWidgetUpdate: () {
              setState(() {
                db.update({"lives": i + 1});
                lives = i + 1;
              });
            },
          )),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Row MedalRow(int init, int length) {
    return Row(
      children: [
        for (int i = init; i < length; i++)
          Expanded(
            child: MedalSnapshot(
              db: db,
              path: medals[i],
              index: i,
              medalCount: medalCount,
              onMedalsChanged: () {
                setState(() {
                  db.update({"medals": i + 1});
                  medalCount = i + 1;
                });
              },
            ),
          ),
      ],
    );
  }
}

class MedalSnapshot extends StatefulWidget {
  final VoidCallback onMedalsChanged;
  final String path;
  final int index;
  late int medalCount;
  MedalSnapshot({
    required this.path,
    required this.index,
    required this.medalCount,
    required this.db,
    required this.onMedalsChanged,
    Key? key,
  }) : super(key: key);

  final DocumentReference<Map<String, dynamic>> db;

  @override
  State<MedalSnapshot> createState() => _MedalSnapshotState();
}

class _MedalSnapshotState extends State<MedalSnapshot> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.db.collection("medals").doc(widget.path).snapshots(),
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
          return IconButton(
            icon: (widget.index > widget.medalCount - 1)
                ? ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                        Colors.black38, BlendMode.modulate),
                    child: Image.asset("assets/medals/" + doc["name"] + ".png"),
                  )
                : Stack(children: [
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                          Colors.black, BlendMode.modulate),
                      child: DropShadowImage(
                        image: Image.asset(
                            "assets/medals/" + doc["name"] + ".png"),
                        blurRadius: 5.0,
                        offset: Offset(3.0, 3.0),
                      ),
                    ),
                    Image.asset("assets/medals/" + doc["name"] + ".png"),
                  ]),
            onPressed: widget.onMedalsChanged,
          );
        } else {
          return const Center(child: Text("doc is null!"));
        }
      },
    );
  }
}

class HeartSnapshot extends StatefulWidget {
  final VoidCallback onWidgetUpdate;
  final int index;
  late int lives;
  HeartSnapshot({
    required this.index,
    required this.lives,
    required this.db,
    required this.onWidgetUpdate,
    Key? key,
  }) : super(key: key);

  final DocumentReference<Map<String, dynamic>> db;

  @override
  State<HeartSnapshot> createState() => _HeartSnapshotState();
}

class _HeartSnapshotState extends State<HeartSnapshot> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: (widget.index > widget.lives - 1)
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black38, BlendMode.modulate),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset("assets/heart.png"),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset("assets/heart.png"),
            ),
      onPressed: widget.onWidgetUpdate,
      iconSize: 50,
    );
  }
}

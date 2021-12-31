// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locketrack/custom_classes/medal.dart';
import 'package:locketrack/screens/list_pokemon.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:confetti/confetti.dart';

class CoachToken extends StatefulWidget {
  final DocumentReference<Map<String, dynamic>> docID;
  final List<Medal> medalsList;
  final String gameName;
  const CoachToken({
    required this.docID,
    required this.medalsList,
    required this.gameName,
    Key? key,
  }) : super(key: key);

  @override
  State<CoachToken> createState() => _CoachTokenState();
}

class _CoachTokenState extends State<CoachToken> {
  late DocumentReference<Map<String, dynamic>> db;
  late int lives = 10;
  late int medalCount = 0;
  late int gen = 0;
  bool confetti = false;
  List<String> medals = [];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    db = widget.docID;
    generateMedals(db.collection("medals"), widget.medalsList);
    getCoachInfo(db);
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  void generateMedals(CollectionReference<Map<String, dynamic>> collection,
      List<Medal> medals) {
    collection.get().then((value) {
      if (value.size == 0) {
        int i = 1;
        // ignore: avoid_function_literals_in_foreach_calls
        medals.forEach((element) async {
          await collection.add({
            'name': element.name,
            'lvl': element.lvl,
            'index': i++,
          });
        });
      }
    }).then((value) => loadMedals());
  }

  void loadMedals() async {
    await db.collection("medals").orderBy("index").get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        medals.add(result.id);
      }
    });
    await db.get().then((value) => gen = value.data()?["gen"]);
    setState(() {
      print("Medals loaded");
    });
  }

  void getCoachInfo(DocumentReference<Map<String, dynamic>> doc) async {
    await doc.get().then((value) => lives = value.data()?["lives"]);
    await doc.get().then((value) => medalCount = value.data()?["medals"]);
    await doc.get().then((value) => gen = value.data()?["gen"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Locke Progression"),
      ),
      body: (medals.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                    child: Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: const Color.fromRGBO(64, 70, 156, 1),
                          ),
                          color: const Color.fromRGBO(54, 59, 129, 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CenteredHeader(
                              text: "Medals",
                            ),
                            if (gen != 7) MedalRow(0, medals.length ~/ 2),
                            if (gen != 7)
                              MedalRow(medals.length ~/ 2, medals.length),
                            if (gen == 7) MedalRow(0, medals.length ~/ 3),
                            if (gen == 7)
                              MedalRow(
                                  medals.length ~/ 3, medals.length ~/ 3 * 2),
                            if (gen == 7)
                              MedalRow(medals.length ~/ 3 * 2, medals.length),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                    child: Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: const Color.fromRGBO(207, 37, 37, 1),
                          ),
                          color: Colors.red[900],
                        ),
                        child: Column(
                          children: [
                            const CenteredHeader(
                              text: "Lives",
                            ),
                            LiveRow(0, 5),
                            LiveRow(5, 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                    child: Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: const Color.fromRGBO(20, 110, 34, 1),
                          ),
                          color: Colors.green[900],
                        ),
                        child: Column(
                          children: [
                            const CenteredHeader(
                              text: "Team",
                            ),
                            LiveRow(0, 5),
                            LiveRow(5, 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
              gameName: widget.gameName,
              path: medals[i],
              index: i,
              maxMedals: medals.length,
              medalCount: medalCount,
              onMedalsChanged: () {
                setState(() {
                  db.update({"medals": i + 1});
                  medalCount = i + 1;
                });
              },
              onConfettiBlast: () {
                setState(() {
                  confetti = !confetti;
                });
              },
            ),
          ),
      ],
    );
  }
}

class Confetti extends StatefulWidget {
  const Confetti({
    Key? key,
  }) : super(key: key);

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> {
  late ConfettiController controller;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    controller = ConfettiController(duration: const Duration(seconds: 2));
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: controller,
        // ignore: prefer_const_literals_to_create_immutables
        colors: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.purple,
        ],
        shouldLoop: true,
        emissionFrequency: 0.05,
        numberOfParticles: 5,
        blastDirectionality: BlastDirectionality.explosive,
        gravity: 0.5,
        maxBlastForce: 30,
      ),
    );
  }
}

int calcEnd(int i, int length) {
  int j = i;
  if (i + 5 < length) {
    j += 5;
  } else {
    j = length;
  }
  return j;
}

class CenteredHeader extends StatelessWidget {
  final String text;
  const CenteredHeader({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class MedalSnapshot extends StatefulWidget {
  final VoidCallback onMedalsChanged;
  final VoidCallback onConfettiBlast;
  final String gameName;
  final String path;
  final int index;
  final int maxMedals;
  late int medalCount;
  MedalSnapshot({
    required this.gameName,
    required this.path,
    required this.index,
    required this.medalCount,
    required this.maxMedals,
    required this.db,
    required this.onMedalsChanged,
    required this.onConfettiBlast,
    Key? key,
  }) : super(key: key);

  final DocumentReference<Map<String, dynamic>> db;

  @override
  State<MedalSnapshot> createState() => _MedalSnapshotState();
}

class _MedalSnapshotState extends State<MedalSnapshot> {
  void congratulationsDialogue() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "CONGRATULATIONS!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 24.0,
          backgroundColor: const Color.fromRGBO(46, 46, 46, 1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
            side: BorderSide(
              width: 3,
              color: Colors.black,
            ),
          ),
          content: SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              children: [
                Text(
                  "You completed your ${widget.gameName} nuzlocke run!",
                  textAlign: TextAlign.center,
                ),
                const Confetti()
              ],
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                child: const Text(
                  "OK",
                  style: TextStyle(fontSize: 20),
                ),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  widget.onConfettiBlast();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

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
          return Column(
            children: [
              IconButton(
                icon: (widget.index > widget.medalCount - 1)
                    ? ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            Color.fromRGBO(11, 16, 64, 1), BlendMode.modulate),
                        child: Image.asset(
                            "assets/medals/" + doc["name"] + ".png"),
                      )
                    : Stack(children: [
                        ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                              Color.fromRGBO(7, 10, 41, 1), BlendMode.modulate),
                          child: DropShadowImage(
                            image: Image.asset(
                                "assets/medals/" + doc["name"] + ".png"),
                            blurRadius: 5.0,
                            offset: const Offset(3.0, 3.0),
                          ),
                        ),
                        Image.asset("assets/medals/" + doc["name"] + ".png"),
                      ]),
                onPressed: () {
                  widget.onMedalsChanged();
                  if (widget.index == widget.maxMedals - 1) {
                    congratulationsDialogue();
                  }
                  widget.onConfettiBlast();
                },
                iconSize: 40,
              ),
              Text(
                "lvl: ${doc["lvl"]}",
                textAlign: TextAlign.center,
              ),
            ],
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
              colorFilter: const ColorFilter.mode(
                  Color.fromRGBO(38, 8, 8, 1), BlendMode.modulate),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/heart.png"),
              ),
            )
          : Stack(children: [
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                    Color.fromRGBO(18, 4, 4, 1), BlendMode.modulate),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropShadowImage(
                    image: Image.asset("assets/heart.png"),
                    blurRadius: 5.0,
                    offset: const Offset(3.0, 3.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/heart.png"),
              ),
            ]),
      onPressed: widget.onWidgetUpdate,
      iconSize: 50,
    );
  }
}

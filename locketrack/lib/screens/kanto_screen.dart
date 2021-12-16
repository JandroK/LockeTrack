import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locketrack/custom_classes/route.dart';
import 'package:locketrack/screens/coach_token.dart';

class KantoScreen extends StatefulWidget {
  KantoScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<KantoScreen> createState() => _KantoScreenState();
}

class _KantoScreenState extends State<KantoScreen> {
  final db = FirebaseFirestore.instance;
  List<String> routes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    drawRoutes();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void drawRoutes() async {
    await db.collection("rutas").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        routes.add(result.id);
      });
    });
    setState(() {
      // Update your UI with the desired changes.
      print("Ya he cargado los path");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokémon Rojo Fuego"),
      ),
      floatingActionButton: FloatingActionButton(
        child:
            const Icon(Icons.backpack_outlined, size: 40, color: Colors.white),
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CoachToken(),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: routes.length,
                itemBuilder: (BuildContext context, int index) {
                  return RouteContainer(db: db, path: routes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RouteContainer extends StatelessWidget {
  final FirebaseFirestore db;
  final String path;
  const RouteContainer({
    required this.db,
    required this.path,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 5),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: RouteSnapshot(db: db, path: path),
    );
  }
}

class RouteSnapshot extends StatelessWidget {
  final String path;
  const RouteSnapshot({
    required this.path,
    required this.db,
    Key? key,
  }) : super(key: key);

  final FirebaseFirestore db;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.doc("/rutas/$path").snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final doc = snapshot.data!.data();
        if (doc != null) {
          return RouteInfo(
              routeInfo: RouteClass.fromFireBase(doc),
              doc: db.doc("/rutas/$path"));
        } else {
          return const Center(child: Text("doc is null!"));
        }
      },
    );
  }
}

class RouteInfo extends StatelessWidget {
  final RouteClass routeInfo;
  final dynamic doc;
  const RouteInfo({
    required this.routeInfo,
    required this.doc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(routeInfo.routeName),
                  const SizedBox(height: 10),
                  InputText(fieldName: "Pokémon: ", name: ""),
                  const SizedBox(height: 10),
                  InputText(fieldName: "Status:      ", name: ""),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: const Icon(Icons.add, size: 70),
            ),
          ],
        ),
        Row(
          children: [
            CheckBoxText(name: "Failed", active: routeInfo.failed, doc: doc),
            CheckBoxText(name: "Dead", active: routeInfo.dead, doc: doc),
            CheckBoxText(name: "Shiny", active: routeInfo.shiny, doc: doc),
            CheckBoxText(name: "Team", active: routeInfo.team, doc: doc),
          ],
        )
      ],
    );
  }
}

class CheckBoxText extends StatefulWidget {
  final String name;
  final DocumentReference<Map<String, dynamic>> doc;
  bool active;
  //final bool? active;
  CheckBoxText({
    required this.name,
    required this.doc,
    required this.active,
    //required this.active,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckBoxText> createState() => _CheckBoxTextState();
}

class _CheckBoxTextState extends State<CheckBoxText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.name),
        Checkbox(
          value: widget.active,
          onChanged: (bool? value) {
            setState(() {
              widget.doc.update({
                '${widget.name[0].toLowerCase()}${widget.name.substring(1)}':
                    value!,
              });
            });
          },
        ),
      ],
    );
  }
}

class InputText extends StatelessWidget {
  String fieldName = "";
  String name = "";
  InputText({
    this.fieldName = "",
    this.name = "",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(fieldName),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Text(name),
        ),
      )
    ]);
  }
}

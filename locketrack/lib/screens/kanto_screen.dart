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

  void drawRoutes() {
    db.collection("rutas").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        routes.add(result.id);
      });
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
          return RouteInfo(routeName: RouteClass.fromFireBase(doc));
        } else {
          return const Center(child: Text("doc is null!"));
        }
      },
    );
  }
}

class RouteInfo extends StatelessWidget {
  final RouteClass routeName;
  const RouteInfo({
    required this.routeName,
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
                  Text(routeName.routeName),
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
          children: const [
            CheckBoxText(name: "Failed"),
            CheckBoxText(name: "Dead"),
            CheckBoxText(name: "Shiny"),
            CheckBoxText(name: "Team"),
          ],
        )
      ],
    );
  }
}

class CheckBoxText extends StatelessWidget {
  final String name;
  //final bool? active;
  const CheckBoxText({
    required this.name,
    //required this.active,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(name),
        Checkbox(value: false, onChanged: (bool? value) {}),
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

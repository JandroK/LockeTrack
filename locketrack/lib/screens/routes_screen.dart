import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locketrack/custom_classes/route.dart';
import 'package:locketrack/screens/coach_token.dart';

import 'list_pokemon.dart';

class RouteScreen extends StatefulWidget {
  final String docID;
  RouteScreen({
    required this.docID,
    Key? key,
  }) : super(key: key);

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  late DocumentReference<Map<String, dynamic>> db;
  late String gameName = "";
  List<String> routes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance.collection("regions").doc(widget().docID);
    generateNewDoc(db.collection("routes"), kantoRouteList);
    getGameName(db);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getGameName(DocumentReference<Map<String, dynamic>> doc) async {
    await doc.get().then((value) => gameName = value.data()?["name"]);
  }

  void generateNewDoc(CollectionReference<Map<String, dynamic>> collection,
      List<String> routeName) {
    collection.get().then((value) {
      if (value.size == 1) {
        int i = 0;
        routeName.forEach((element) async {
          await collection.add({
            'nombre': element,
            //'pokemon': "pokemons/zQDOtXNvVNXrRc9iKCNa",
            'status': "",
            'failed': false,
            'dead': false,
            'shiny': false,
            'team': false,
            'index': i++,
          });
        });
      }
    }).then((value) => drawRoutes());
  }

  void drawRoutes() async {
    await db.collection("routes").orderBy("index").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        routes.add(result.id);
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
        title: (gameName != "") ? Text("Pokémon $gameName") : Text(""),
      ),
      floatingActionButton: FloatingActionButton(
        child:
            const Icon(Icons.backpack_outlined, size: 40, color: Colors.white),
        backgroundColor: Colors.orange[700],
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CoachToken(
                docID: widget().docID,
              ),
            ),
          );
        },
      ),
      body: (routes.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: routes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RouteSnapshot(db: db, path: routes[index]);
                    },
                  ),
                ),
              ],
            ),
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

  final DocumentReference<Map<String, dynamic>> db;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.collection("routes").doc(path).snapshots(),
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
          return RouteInfo(
              routeInfo: RouteClass.fromFireBase(doc),
              doc: db.collection("routes").doc(path));
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
  final List<String> statusList = ["Finded", "Gifted", "Traded", "Egg"];
  RouteInfo({
    required this.routeInfo,
    required this.doc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(
          width: 5,
          color: (routeInfo.status == "")
              ? Colors.grey
              : (routeInfo.shiny)
                  ? Colors.yellow
                  : (routeInfo.failed || routeInfo.dead)
                      ? Colors.red
                      : Colors.green,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 5.0,
            spreadRadius: 3.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  routeInfo.routeName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              GestureDetector(
                child: const Icon(Icons.settings_backup_restore_rounded),
                onTap: () {
                  resetValues(doc);
                },
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    InputText(fieldName: "Pokémon: ", name: ""),
                    const SizedBox(height: 10),
                    DropdownButtonContainer(
                        fieldName: "status",
                        name: "Status:      ",
                        statusList: statusList,
                        status: routeInfo.status,
                        doc: doc),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Pokedex(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  child: Transform.rotate(
                    angle: 180 * 3.141516 / 180,
                    child: const Icon(Icons.catching_pokemon, size: 60),
                  ),
                ),
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
      ),
    );
  }
}

class DropdownButtonContainer extends StatefulWidget {
  const DropdownButtonContainer({
    Key? key,
    required this.statusList,
    required this.status,
    required this.fieldName,
    required this.name,
    required this.doc,
  }) : super(key: key);

  final List<String> statusList;
  final String status;
  final String fieldName;
  final String name;
  final DocumentReference<Map<String, dynamic>> doc;

  @override
  State<DropdownButtonContainer> createState() =>
      _DropdownButtonContainerState();
}

class _DropdownButtonContainerState extends State<DropdownButtonContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(widget().name),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: DropdownButton(
            style: const TextStyle(color: Colors.white, fontSize: 14.0),
            isDense: true,
            isExpanded: true,
            itemHeight: null,
            items: widget()
                .statusList
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            hint: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(widget().status),
            ),
            onChanged: (value) => {
              setState(() {
                widget().doc.update({
                  widget().fieldName: value,
                });
              })
            },
          ),
        ),
      )
    ]);
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
        Text(widget().name),
        Checkbox(
          activeColor: Colors.orange,
          value: widget().active,
          onChanged: (bool? value) {
            setState(() {
              widget().doc.update({
                '${widget().name[0].toLowerCase()}${widget().name.substring(1)}':
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
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(name),
          ),
        ),
      )
    ]);
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locketrack/custom_classes/medal.dart';
import 'package:locketrack/custom_classes/route.dart';
import 'package:locketrack/screens/coach_token.dart';
import 'package:palette_generator/palette_generator.dart';

import 'list_pokemon.dart';

// global variable
bool search = false;

class RouteScreen extends StatefulWidget {
  DocumentReference<Map<String, dynamic>> docID;
  final int index;
  RouteScreen({required this.docID, required this.index, super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  late TextEditingController controller;
  late DocumentReference<Map<String, dynamic>> db;
  late String gameName = "";
  List<String> routesID = [];

  @override
  void initState() {
    super.initState();
    db = widget.docID;
    generateRoutes(db.collection("routes"), regionRouteList[widget.index]);
    getGameName(db);
    controller = TextEditingController(text: "");
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void getGameName(DocumentReference<Map<String, dynamic>> doc) async {
    await doc.get().then((value) => gameName = value.data()?["name"]);
  }

  void generateRoutes(
    CollectionReference<Map<String, dynamic>> collection,
    List<String> routeName,
  ) {
    collection
        .get()
        .then((value) {
          if (value.size == 0) {
            int i = 0;
            routeName.forEach((element) async {
              await collection.add({
                'nombre': element,
                'pokeObt': "",
                'pokeDel': "",
                'pokeObtNum': "",
                'pokeDelNum': "",
                'status': "",
                'type1': "",
                'type2': "",
                'failed': false,
                'dead': false,
                'shiny': false,
                'team': false,
                'index': i++,
              });
            });
          }
        })
        .then((value) => loadRoutes());
  }

  void loadRoutes() async {
    await db.collection("routes").orderBy("index").get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        routesID.add(result.id);
      }
    });
    setState(() {
      print("Ya he cargado los path");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (gameName != "")
            ? Text("Pokémon $gameName", style: const TextStyle(fontSize: 16))
            : Text(""),
        actions: [
          IconButton(
            icon: Icon(
              (search == false)
                  ? Icons.search_rounded
                  : Icons.search_off_rounded,
            ),
            onPressed: () {
              setState(() {
                search = !search;
              });
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[700],
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CoachToken(
                docID: widget.docID,
                medalsList: regionMedalList[widget.index],
                gameName: gameName,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.backpack_outlined,
          size: 40,
          color: Colors.white,
        ),
      ),
      body: (routesID.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (search)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: TextField(
                              controller: controller,
                              cursorColor: Colors.orange,
                              decoration: const InputDecoration(
                                hintText: "Route Name",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                ),
                              ),
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(55, 30),
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            side: const BorderSide(color: Colors.white54),
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text(
                            "Search",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: routesID.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RouteSnapshot(
                        db: db,
                        path: routesID[index],
                        findRoute: controller.text,
                      );
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
  final String findRoute;
  const RouteSnapshot({
    required this.path,
    required this.findRoute,
    required this.db,
    super.key,
  });

  final DocumentReference<Map<String, dynamic>> db;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.collection("routes").doc(path).snapshots(),
      builder:
          (
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
                routeInfo: RouteClass.fromFireBasse(doc),
                doc: db.collection("routes").doc(path),
                findRoute: findRoute,
              );
            } else {
              return const Center(child: Text("doc is null!"));
            }
          },
    );
  }
}

class RouteInfo extends StatelessWidget {
  final RouteClass routeInfo;
  final String findRoute;
  final dynamic doc;
  final List<String> statusList = ["Finded", "Gifted", "Traded", "Egg"];
  RouteInfo({
    required this.routeInfo,
    required this.findRoute,
    required this.doc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if ((search && equalsIgnoreCase(routeInfo.routeName, findRoute)) ||
        !search) {
      if (routeInfo.pokemonObtNum != "") {
        return FutureBuilder(
          future: paletteGenerator(routeInfo.pokemonObtNum),
          builder:
              (
                BuildContext context,
                AsyncSnapshot<PaletteGenerator> snapshotObt,
              ) {
                if (!snapshotObt.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (routeInfo.pokemonDelNum != "") {
                  return FutureBuilder(
                    future: paletteGenerator(routeInfo.pokemonDelNum),
                    builder:
                        (
                          BuildContext context,
                          AsyncSnapshot<PaletteGenerator> snapshotDel,
                        ) {
                          if (!snapshotDel.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ContainerRoute(
                            true,
                            snapshotDel.data!.dominantColor!.color,
                            snapshotObt.data!.dominantColor!.color,
                          );
                        },
                  );
                }
                return ContainerRoute(
                  true,
                  snapshotObt.data!.dominantColor!.color,
                  snapshotObt.data!.dominantColor!.color,
                );
              },
        );
      }
      return ContainerRoute(false, Colors.black38, Colors.black38);
    }
    return const Center();
  }

  Container ContainerRoute(bool future, Color colorObt, Color colorDel) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.all(
          width: 5,
          color: (routeInfo.pokemonObt == "")
              ? Colors.grey
              : (routeInfo.shiny)
              ? Colors.yellow
              : (routeInfo.failed || routeInfo.dead)
              ? Colors.red
              : Colors.green,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorObt.withAlpha(220), colorDel.withAlpha(220)],
          stops: const [0.4, 0.6],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            spreadRadius: 3.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          ),
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
                child: const Icon(Icons.refresh_rounded),
                onTap: () {
                  resetValues(doc);
                },
              ),
            ],
          ),
          PokemonInfo(routeInfo: routeInfo, statusList: statusList, doc: doc),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CheckBoxText(name: "Failed", active: routeInfo.failed, doc: doc),
              CheckBoxText(name: "Dead", active: routeInfo.dead, doc: doc),
              CheckBoxText(name: "Shiny", active: routeInfo.shiny, doc: doc),
              CheckBoxText(name: "Team", active: routeInfo.team, doc: doc),
            ],
          ),
        ],
      ),
    );
  }
}

class PokemonInfo extends StatelessWidget {
  const PokemonInfo({
    super.key,
    required this.routeInfo,
    required this.statusList,
    required this.doc,
  });

  final RouteClass routeInfo;
  final List<String> statusList;
  final doc;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (routeInfo.status == "Traded")
          PokemonSprite(
            doc: doc,
            traded: true,
            pokeObtNumDex: routeInfo.pokemonObtNum,
            pokeDelNumDex: routeInfo.pokemonDelNum,
          ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              InputText(
                fieldName: "Pokémon:",
                pokeObtained: routeInfo.pokemonObt,
                pokeDelivered: routeInfo.pokemonDel,
                traded: (routeInfo.status == "Traded") ? true : false,
              ),
              const SizedBox(height: 10),
              DropdownButtonContainer(
                fieldName: "status",
                name: "Status:     ",
                statusList: statusList,
                status: routeInfo.status,
                doc: doc,
                traded: (routeInfo.status == "Traded") ? true : false,
              ),
            ],
          ),
        ),
        PokemonSprite(
          doc: doc,
          traded: false,
          pokeObtNumDex: routeInfo.pokemonObtNum,
          pokeDelNumDex: routeInfo.pokemonDelNum,
        ),
      ],
    );
  }
}

class PokemonSprite extends StatefulWidget {
  final DocumentReference<Map<String, dynamic>> doc;
  final bool traded;
  final String pokeObtNumDex;
  final String pokeDelNumDex;
  const PokemonSprite({
    required this.doc,
    required this.traded,
    required this.pokeObtNumDex,
    required this.pokeDelNumDex,
    super.key,
  });

  @override
  State<PokemonSprite> createState() => _PokemonSpriteState();
}

class _PokemonSpriteState extends State<PokemonSprite> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Pokedex()))
            .then((value) {
              if (value != null) {
                setState(() {
                  (!widget.traded)
                      ? widget.doc.update({
                          'pokeObt': value.name,
                          'pokeObtNum': value.numberDex.toString().substring(1),
                          'type1': value.types[0],
                          'type2': value.types[1],
                        })
                      : widget.doc.update({
                          'pokeDel': value.name,
                          'pokeDelNum': value.numberDex.toString().substring(1),
                          'type1': value.types[0],
                          'type2': value.types[1],
                        });
                });
              }
            });
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (widget.pokeObtNumDex == "") ? Colors.orange : Colors.white38,
          boxShadow: [
            (widget.pokeObtNumDex == "")
                ? const BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  )
                : const BoxShadow(color: Colors.white10),
          ],
        ),
        child:
            (widget.pokeObtNumDex == "" ||
                (widget.pokeDelNumDex == "" && widget.traded))
            ? Transform.rotate(
                angle: 180 * 3.141516 / 180,
                child: const Padding(
                  padding: EdgeInsets.all(7.5),
                  child: Icon(Icons.catching_pokemon, size: 60),
                ),
              )
            : (!widget.traded)
            ? Image.asset(
                "assets/sprites/${widget.pokeObtNumDex}.png",
                height: 75,
              )
            : Image.asset(
                "assets/sprites/${widget.pokeDelNumDex}.png",
                height: 75,
              ),
      ),
    );
  }
}

class DropdownButtonContainer extends StatefulWidget {
  const DropdownButtonContainer({
    super.key,
    required this.statusList,
    required this.status,
    required this.fieldName,
    required this.name,
    required this.traded,
    required this.doc,
  });

  final List<String> statusList;
  final String status;
  final String fieldName;
  final String name;
  final bool traded;
  final DocumentReference<Map<String, dynamic>> doc;

  @override
  State<DropdownButtonContainer> createState() =>
      _DropdownButtonContainerState();
}

class _DropdownButtonContainerState extends State<DropdownButtonContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!widget.traded) Text(widget.name),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: DropdownButton(
                style: const TextStyle(color: Colors.white, fontSize: 14.0),
                isDense: true,
                isExpanded: true,
                itemHeight: null,
                items: widget.statusList
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                hint: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(widget.status),
                ),
                onChanged: (value) => {
                  setState(() {
                    widget.doc.update({widget.fieldName: value});
                  }),
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Cambiar por TextButton (cuando esta marcado el color background es de otro color)
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
    super.key,
  });

  @override
  State<CheckBoxText> createState() => _CheckBoxTextState();
}

class _CheckBoxTextState extends State<CheckBoxText> {
  bool alert = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
          onPressed: () async {
            bool full = false;
            if (widget.name == "Team") {
              full = await UpdateTeamMember(widget.doc, widget.active);
            }
            if (!full) {
              widget.doc.update({
                '${widget.name[0].toLowerCase()}${widget.name.substring(1)}':
                    !widget.active,
              });
            } else {
              WarningDialogue(context);
            }
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(55, 30),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            side: const BorderSide(color: Colors.white54),
            backgroundColor: (widget.active) ? Colors.orange : null,
          ),
          child: Text(widget.name, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Future<dynamic> WarningDialogue(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "WARNING",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Team is full. Delete a tem member before adding a new one.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            Center(
              child: TextButton(
                child: const Text("OK", style: TextStyle(fontSize: 20)),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ignore: non_constant_identifier_names
Future<bool> UpdateTeamMember(
  DocumentReference<Map<String, dynamic>> doc,
  bool active,
) async {
  int pokemons = 0;
  bool written = false;
  await doc.parent.parent!.collection("team").orderBy("index").get().then((
    querySnapshot,
  ) async {
    for (var result in querySnapshot.docs) {
      String reference = await result.data()["reference"];
      if (!written && !active && reference == "") {
        doc.parent.parent!.collection("team").doc(result.id).update({
          "reference": doc.id,
        });
        written = true;
      } else if (!written && active && reference == doc.id) {
        doc.parent.parent!.collection("team").doc(result.id).update({
          "reference": "",
        });
        written = true;
      }
      if (reference != "") {
        pokemons++;
      }
    }
  });
  return pokemons == 6;
}

class InputText extends StatelessWidget {
  String fieldName = "";
  String pokeObtained = ""; // pokemonObtained
  String pokeDelivered = ""; // pokemonDelivered
  bool traded = false;
  InputText({
    this.fieldName = "",
    this.pokeObtained = "",
    this.pokeDelivered = "",
    this.traded = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!traded) Text(fieldName),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (traded) Text(pokeDelivered),
                        if (traded) const Icon(Icons.repeat_rounded, size: 20),
                      ],
                    ),
                    Text(pokeObtained),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

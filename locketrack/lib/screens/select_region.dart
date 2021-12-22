import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locketrack/screens/routes_screen.dart';

class RegionNameMap extends StatefulWidget {
  DocumentReference<Map<String, dynamic>> db;
  RegionNameMap({
    required this.db,
    Key? key,
  }) : super(key: key);

  @override
  State<RegionNameMap> createState() => _RegionNameMapState();
}

class _RegionNameMapState extends State<RegionNameMap> {
  late DocumentReference<Map<String, dynamic>> db;
  final List<String> regions = [];
  final List<String> nameGames = [
    "FireRed and LeafGreen",
    "Gold and Silver",
    "Ruby and Sapphire",
    "Diamond and Pearl",
    "Black and White",
    "X and Y",
    "Sun and Moon",
    "Sword and Shield"
  ];
  final List<String> imagePath = [
    "kanto_map.png",
    "johto_map.png",
    "hoenn_map.png",
    "sinnoh_map.png",
    "teselia_map.png",
    "kalos_map.png",
    "alola_map.png",
    "galar_map.png"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = widget.db;
    generateRegions(db.collection("regions"), nameGames);
  }

  void generateRegions(CollectionReference<Map<String, dynamic>> collection,
      List<String> nameGames) {
    collection.get().then((value) {
      if (value.size == 0) {
        int i = 1;
        nameGames.forEach((element) async {
          await collection.add({'gen': i++, 'name': element});
        });
      }
    }).then((value) => loadRegions());
  }

  void loadRegions() async {
    await db.collection("regions").orderBy("gen").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        regions.add(result.id);
        print(result.id);
      });
    });
    setState(() {
      print("Ya he cargado las regiones");
    });
  }

  void deleteRegion(String path) async {
    await db.collection("regions").doc(path).collection("routes").get().then(
          (value) => value.docs.forEach(
            (element) {
              element.reference.delete();
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokémon regions"), actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
        )
      ]),
      body: (regions.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      const Text("Select Region",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                              fontSize: 24)),
                      const SizedBox(height: 5),
                      for (int i = 0; i < imagePath.length; i++)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Ink(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/maps/${imagePath[i]}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    deleteRegion(regions[i]);
                                  },
                                  child: const Align(
                                      alignment: Alignment.topRight,
                                      child: Icon(
                                        Icons.refresh_rounded,
                                        color: Colors.black,
                                        size: 30,
                                      )),
                                ),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RouteScreen(
                                        docID: db
                                            .collection("regions")
                                            .doc(regions[i]),
                                        index: i),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 10)
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

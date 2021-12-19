import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locketrack/screens/routes_screen.dart';

class RegionNameMap extends StatefulWidget {
  RegionNameMap({
    Key? key,
  }) : super(key: key);

  @override
  State<RegionNameMap> createState() => _RegionNameMapState();
}

class _RegionNameMapState extends State<RegionNameMap> {
  final db = FirebaseFirestore.instance;

  final List<String> regions = [];
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
    loadRegions();
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

  @override
  Widget build(BuildContext context) {
    return (regions.isEmpty)
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
                              image: AssetImage("assets/maps/${imagePath[i]}"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  print("objectTTTTTTTTTTTTT");
                                },
                                child: const Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.settings_backup_restore_rounded,
                                      color: Colors.black,
                                      size: 30,
                                    )),
                              ),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            onTap: () {
                              // Temporal condition, when all region have routes it will not be necessary
                              if (i == 0) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        RouteScreen(docID: regions[i])));
                              }
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 10)
                  ],
                ),
              )
            ],
          );
  }
}

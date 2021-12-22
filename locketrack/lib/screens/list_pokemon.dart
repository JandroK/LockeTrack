import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Pokedex extends StatefulWidget {
  Pokedex({
    Key? key,
  }) : super(key: key);

  @override
  State<Pokedex> createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  final db = FirebaseFirestore.instance;
  bool cath = false;
  List<String> routes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void generatePokemons(CollectionReference<Map<String, dynamic>> collection,
      List<String> pokedex) {
    collection.get().then((value) {
      if (value.size == 0) {
        int i = 0;
        pokedex.forEach((element) async {
          await collection.add({
            'name': element,
            'number_dex': "",
            'type1': "",
            'type2': "",
          });
        });
      }
    }).then((value) => loadPokemons());
  }

  void loadPokemons() async {
    await db.collection("pokemons").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        routes.add(result.id);
      });
    });
    setState(() {
      // Update your UI with the desired changes.
      print("Load pokemons id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokédex"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {},
              // Probar a hacer un degradado segun los tipos
              style: ElevatedButton.styleFrom(primary: Colors.black38),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Text("#001"),
                              const SizedBox(width: 20),
                              const Text("Bulbasaur"),
                              Expanded(
                                child: IconButton(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.all(0),
                                  constraints:
                                      const BoxConstraints(maxHeight: 34),
                                  icon: Icon((cath)
                                      ? Icons.star_border_rounded
                                      : Icons.star_rate_rounded),
                                  onPressed: () {
                                    setState(() {
                                      cath = !cath;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ContainerType("Type"),
                              ContainerType("Type"),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                      child: Transform.rotate(
                          angle: 180 * math.pi / 180,
                          child: const Icon(Icons.catching_pokemon_rounded,
                              size: 60)),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Expanded ContainerType(String type) {
    return Expanded(
      child: Container(
        child: Text(
          type,
          textAlign: TextAlign.center,
        ),
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: Colors.white, width: 1),
        ),
      ),
    );
  }
}

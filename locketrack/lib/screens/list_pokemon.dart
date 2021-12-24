import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:locketrack/custom_classes/pokedex.dart';

class Pokedex extends StatefulWidget {
  Pokedex({
    Key? key,
  }) : super(key: key);

  @override
  State<Pokedex> createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  final db = FirebaseFirestore.instance.collection("pokemons");
  List<String> pokemonsID = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generatePokemons(db);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void generatePokemons(CollectionReference<Map<String, dynamic>> collection) {
    collection.get().then((value) {
      if (value.size == 1) {
        loadPokedex().then((value) {
          value.forEach((element) async {
            await collection.add({
              'number_dex': element.numberDex,
              'name': element.name,
              'type1': element.types[0],
              'type2': (element.types.length > 1) ? element.types[1] : "",
            });
          });
        });
      }
    }).then((value) => loadPokemons());
  }

  void loadPokemons() async {
    await db.orderBy("number_dex").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        pokemonsID.add(result.id);
      });
    }).then((value) => pokemonsID.remove(pokemonsID[0]));
    setState(() {
      print("Load pokemons id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokédex"),
      ),
      body: (pokemonsID.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: pokemonsID.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PokemonSnapshot(db: db.doc(pokemonsID[index]));
                      //findRoute: controller.text);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class PokemonSnapshot extends StatelessWidget {
  //final String findRoute;
  const PokemonSnapshot({
    //required this.findRoute,
    required this.db,
    Key? key,
  }) : super(key: key);

  final DocumentReference<Map<String, dynamic>> db;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.snapshots(),
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
          return PokemonInfo(
            pokemonInfo: Pokemon.fromFireBase(doc),
            //findRoute: findRoute,
          );
        } else {
          return const Center(child: Text("doc is null!"));
        }
      },
    );
  }
}

class PokemonInfo extends StatefulWidget {
  final Pokemon pokemonInfo;
  //final String findRoute;
  const PokemonInfo({
    required this.pokemonInfo,
    //required this.findRoute,
    Key? key,
  }) : super(key: key);

  @override
  State<PokemonInfo> createState() => _PokemonInfoState();
}

class _PokemonInfoState extends State<PokemonInfo> {
  bool cath = false;
  bool shiny = false;

  Expanded containerType(String type) {
    return Expanded(
      child: Container(
        child: Text(type, textAlign: TextAlign.center),
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: Colors.white, width: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: ElevatedButton(
        onPressed: () {},
        // Probar a hacer un degradado segun los tipos
        style: ElevatedButton.styleFrom(primary: Colors.black38),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
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
                        Text(widget.pokemonInfo.numberDex),
                        const SizedBox(width: 20),
                        Text(widget.pokemonInfo.name),
                        const Spacer(),
                        IconButton(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(0),
                          constraints: const BoxConstraints(maxHeight: 34),
                          icon: Icon(
                              (shiny)
                                  ? Icons.star_rate_rounded
                                  : Icons.star_border_rounded,
                              color: (shiny) ? Colors.orange : Colors.white),
                          onPressed: () {
                            setState(() {
                              shiny = !shiny;
                            });
                          },
                        ),
                        Checkbox(
                          activeColor: Colors.orange,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: cath,
                          onChanged: (value) {
                            setState(() {
                              cath = !cath;
                            });
                          },
                          shape: const CircleBorder(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        containerType(widget.pokemonInfo.types[0]),
                        if (widget.pokemonInfo.types[1] != "")
                          containerType(widget.pokemonInfo.types[1]),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 10, top: 8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                  child: Image.asset(
                      "assets/sprites/${widget.pokemonInfo.numberDex.substring(1)}.png"),
                  height: 75)
            ],
          ),
        ),
      ),
    );
  }
}

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

  List<String> routes = [];

  void drawPokemons() async {
    await db.collection("pokemons").get().then((querySnapshot) {
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
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              child: const Text("Back"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(20),
            elevation: 12,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("#"),
                          SizedBox(height: 10),
                          Text("Pokémon: "),
                          SizedBox(height: 10),
                          Text("Status:  "),
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
                              size: 70)),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text("Failed"),
                    Text("Dead"),
                    Text("Shiny"),
                    Text("Team"),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

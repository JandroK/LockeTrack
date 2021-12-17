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
      print("Load Route info");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokédex"),
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
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text("#NUM"),
                            SizedBox(height: 10),
                            Text("Pokémon: Name "),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            size: 70)),
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.all(20),
            elevation: 12,
          )
        ],
      ),
    );
  }

  Container ContainerType(String type) {
    return Container(
      child: Text(type),
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }
}

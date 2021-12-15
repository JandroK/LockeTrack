import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locketrack/custom_classes/medal.dart';
import 'package:locketrack/screens/list_pokemon.dart';

class CoachToken extends StatefulWidget {
  const CoachToken({
    Key? key,
  }) : super(key: key);

  @override
  State<CoachToken> createState() => _CoachTokenState();
}

class _CoachTokenState extends State<CoachToken> {
  final db = FirebaseFirestore.instance;
  List<Medal> medals = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // TODO: cargar los datos del servidor
    medals = [for (int i = 0; i < 8; i++) Medal((i < 3) ? true : false)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokémon Rojo Fuego"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              for (var i in medals)
                Expanded(
                    child: Image(
                        image: AssetImage(
                            i.gained ? i.image_gained : i.image_default))),
            ],
          ),
          /*ListView(
            children: List.generate(
              8,
              (index) => Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: Colors.green),
              ),
            ),
          ),*/
          ElevatedButton(
            child: const Text("Pokedex"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Pokedex(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

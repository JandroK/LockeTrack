import 'package:flutter/material.dart';
import 'package:locketrack/screens/list_pokemon.dart';

class CoachToken extends StatelessWidget {
  const CoachToken({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokémon Rojo Fuego"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Pokedex"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Pokedex(),
              ),
            );
          },
        ),
      ),
    );
  }
}

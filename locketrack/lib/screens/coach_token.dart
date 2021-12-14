import 'package:flutter/material.dart';

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
          child: Text("Go to Back"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

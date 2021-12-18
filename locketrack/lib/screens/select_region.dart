import 'package:flutter/material.dart';
import 'package:locketrack/screens/kanto_screen.dart';

class RegionNameMap extends StatelessWidget {
  final List<Widget> regionScreens = [KantoScreen()];
  final List<String> path = [
    "kanto_map.png",
    "johto_map.png",
    "hoenn_map.png",
    "sinnoh_map.png",
    "teselia_map.png",
    "kalos_map.png",
    "alola_map.png",
    "galar_map.png"
  ];
  RegionNameMap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
              for (int i = 0; i < path.length; i++)
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Ink(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: AssetImage("assets/maps/${path[i]}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      onTap: () {
                        // Temporal condition, when all region have screen it will not be necessary
                        if (regionScreens[i] != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => regionScreens[i]));
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

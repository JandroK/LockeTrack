import 'package:flutter/material.dart';
import 'package:locketrack/screens/rutes.dart';

class RegionNameMap extends StatelessWidget {
  final List<Widget> regionScreens = [RuteScreen()];
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
        const SizedBox(height: 10),
        const Text("Select Region",
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w700,
                fontSize: 24)),
        Expanded(
          child: ListView.builder(
            itemCount: path.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // Temporal condition, when all region have screen it will not be necessary
                  if (regionScreens[index] != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => regionScreens[index]),
                    );
                  }
                },
                child: Container(
                  child: Image.asset("assets/maps/${path[index]}",
                      fit: BoxFit.fitHeight),
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}

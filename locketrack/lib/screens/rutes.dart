import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RuteScreen extends StatefulWidget {
  RuteScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RuteScreen> createState() => _RuteScreenState();
}

class _RuteScreenState extends State<RuteScreen> {
  final db = FirebaseFirestore.instance;
  List<String> routes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    routes = [for (int i = 0; i < 10; i++) "Hola"];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RegionNameMap(name: "Kanto", path: "assets/kanto_map.jpg"),
          const SizedBox(height: 10),
          Container(
            child: const RouteInfo(),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 5),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RouteInfo extends StatelessWidget {
  const RouteInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Route Name"),
                  const SizedBox(height: 10),
                  InputText(fieldName: "Pokémon: ", name: ""),
                  const SizedBox(height: 10),
                  InputText(fieldName: "Status:      ", name: ""),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: const Icon(Icons.add, size: 70),
            ),
          ],
        ),
        Row(
          children: [
            CheckBoxText(name: "Failed"),
            CheckBoxText(name: "Dead"),
            CheckBoxText(name: "Shiny"),
            CheckBoxText(name: "Team"),
          ],
        )
      ],
    );
  }
}

class CheckBoxText extends StatelessWidget {
  String name;
  bool? active;
  CheckBoxText({
    required this.name,
    //required this.active,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(name),
        Checkbox(value: false, onChanged: (bool? value) {}),
      ],
    );
  }
}

class InputText extends StatelessWidget {
  String fieldName = "";
  String name = "";
  InputText({
    this.fieldName = "",
    this.name = "",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(fieldName),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Text(name),
        ),
      )
    ]);
  }
}

class RegionNameMap extends StatelessWidget {
  final String name;
  final String path;
  const RegionNameMap({
    required this.name,
    required this.path,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: const TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w700,
              fontSize: 24),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Image.asset(
            path,
            fit: BoxFit.fitHeight,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
      ],
    );
  }
}

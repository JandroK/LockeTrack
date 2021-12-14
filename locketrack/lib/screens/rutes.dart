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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
              child: Text("Kanto",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                      fontSize: 24))),
          Container(
            margin: const EdgeInsets.only(top: 5),
            height: 300,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage("assets/kanto_map.jpg")),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 5),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Route Name"),
                    Text("Pokémon"),
                    Text("Status")
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.orange),
                  child: const Icon(Icons.add),
                )
              ],
            ),
          )
          // ListView.builder(itemBuilder: (BuildContext context, int index) {
          //   return Container(
          //     //decoration: const BoxDecoration(
          //     //shape: BoxShape.rectangle, color: Colors.green),
          //     child: Text(
          //       routes[index],
          //     ),
          //   );
          // })
        ],
      ),
    );
  }
}

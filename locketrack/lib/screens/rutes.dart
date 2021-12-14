import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class RuteScreen extends StatelessWidget {
  RuteScreen({
    Key? key,
  }) : super(key: key);

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Center(
            child: Text(
              "Kanto",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 24),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            height: 300,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage("assets/kanto_map.jpg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

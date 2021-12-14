import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:locketrack/screens/coach_token.dart';
import 'package:locketrack/screens/rutes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokémon Rojo Fuego")),
      floatingActionButton: FloatingActionButton(
        child:
            const Icon(Icons.backpack_outlined, size: 40, color: Colors.white),
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CoachToken(),
          ));
        },
      ),
      body: RuteScreen(),
    );
  }
}

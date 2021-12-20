import 'package:cloud_firestore/cloud_firestore.dart';

class RouteClass {
  String routeName;
  //String pokemonName;
  String status;
  bool failed;
  bool dead;
  bool shiny;
  bool team;

  RouteClass.fromFireBase(Map<String, dynamic> doc)
      : routeName = doc['nombre'],
        //pokemonName = doc['pokemon'] ?? "",
        status = doc['status'],
        failed = doc['failed'],
        dead = doc['dead'],
        shiny = doc['shiny'],
        team = doc['team'];
}

void deleteRegion(String path, dynamic function) async {
  await FirebaseFirestore.instance
      .collection("regions")
      .doc(path)
      .collection("routes")
      .get()
      .then(
        (value) => value.docs.forEach(
          (element) {
            element.reference.delete();
          },
        ),
      )
      .then((value) => function);
}

void resetValues(DocumentReference<Map<String, dynamic>> doc) {
  doc.update({
    //'pokemon' "pokemons/zQDOtXNvVNXrRc9iKCNa":
    'status': "",
    'failed': false,
    'dead': false,
    'shiny': false,
    'team': false,
  });
}

List<String> kantoRouteList = [
  "Starter",
  "Pueblo Paleta",
  "Ruta 1",
  "Ciudad Verde",
  "Ruta 22",
  "Ruta 2",
  "Bosque Verde",
  "Ciudad Plateada",
  "Ruta 3",
  "Ruta 4",
  "Mt. Moon",
  "Ciudad Celeste",
  "Ruta 24",
  "Ruta 25",
  "Ruta 5",
  "Ruta 6",
  "Ciudad Carmín",
  "Cueva Diglett",
  "Ruta 11",
  "Ruta 9",
  "Ruta 10",
  "Túnel Roca",
  "Ruta 8",
  "Ruta 7",
  "Ciudad Azulona",
  "Torre Pokémon",
  "Ruta 12",
  "Ruta 13",
  "Ruta 14",
  "Ruta 15",
  "Ciudad Fucsia",
  "Zona Safari",
  "Ruta 18",
  "Ruta 17",
  "Ruta 16",
  "Ciudad Azafrán",
  "Silph S.A.",
  "Dojo-Karate",
  "Ruta 21",
  "Isla Canela",
  "Mansión Pokémon",
  "Isla Prima",
  "Isla Secunda",
  "Isla Tera",
  "Rutas 19",
  "Rutas 20",
  "Islas Espuma",
  "Central Energía",
  "Ruta 23",
  "Calle Victoria",
  "Cueva Celeste"
];

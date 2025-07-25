import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class RouteClass {
  String routeName;
  String pokemonObt;
  String pokemonDel;
  String pokemonObtNum;
  String pokemonDelNum;
  String status;
  bool failed;
  bool dead;
  bool shiny;
  bool team;

  RouteClass.fromFireBasse(Map<String, dynamic> doc)
    : routeName = doc['nombre'],
      pokemonObt = doc['pokeObt'],
      pokemonDel = doc['pokeDel'],
      pokemonObtNum = doc['pokeObtNum'],
      pokemonDelNum = doc['pokeDelNum'],
      status = doc['status'],
      failed = doc['failed'],
      dead = doc['dead'],
      shiny = doc['shiny'],
      team = doc['team'];
}

Future<DocumentSnapshot<Map<String, dynamic>>> getPokemonName(String ID) async {
  return await FirebaseFirestore.instance.collection("pokemons").doc(ID).get();
}

bool equalsIgnoreCase(String string1, String string2) {
  return string1.toLowerCase().contains(string2.toLowerCase());
}

Future<PaletteGenerator> paletteGenerator(String path) async {
  return await PaletteGenerator.fromImageProvider(
    AssetImage("assets/sprites/$path.png"),
    maximumColorCount: 25,
  );
}

void resetValues(DocumentReference<Map<String, dynamic>> doc) {
  doc.update({
    'pokeObt': "",
    'pokeDel': "",
    'pokeObtNum': "",
    'pokeDelNum': "",
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
  "Cueva Celeste",
];

List<String> johtoRouteList = [
  "Starter",
  "Pueblo Primavera",
  "Ruta 29",
  "Ruta 46",
  "Ciudad Cerezo",
  "Ruta 30",
  "Ruta 31",
  "Cueva Oscura",
  "Ciudad Malva",
  "Torre Bellsprout",
  "Ruta 32",
  "Ruinas Alfa",
  "Cueva Unión",
  "Ruta 33",
  "Pueblo Azalea",
  "Pozo Slowpoke",
  "Encinar",
  "Ruta 34",
  "Ciudad Trigal",
  "Ruta 35",
  "Parque Nacional",
  "Ruta 36",
  "Ruta 37",
  "Ciudad Iris",
  "Torre Quemada",
  "Torre Campana",
  "Ruta 38",
  "Ruta 39",
  "Ciudad Olivo",
  "Ruta 40",
  "Ruta 41",
  "Islas Remolino",
  "Ciudad Orquídea",
  "Paso Acantilado",
  "Ruta 47",
  "Ruta 48",
  "Torre Oculta",
  "Zona Safari",
  "Ruta 42",
  "Mt. Mortero",
  "Escondite del TR",
  "Ruta 43",
  "Lago de la Furia",
  "Ruta 44",
  "Ruta Helada",
  "Ciudad Endrino",
  "Guarida Dragón",
  "Ruta 45",
  "Ruta 27",
  "Cataratas Tohjo",
  "Ruta 26",
  "Ruta 28",
  "Monte Plateado",
  "Calle Victoria",
];

List<String> hoennRouteList = [
  "Starter",
  "Ruta 101",
  "Ruta 102",
  "Ruta 103",
  "Ciudad Petalia",
  "Ruta 104",
  "Bosque Petalia",
  "Ciudad Férrica",
  "Ruta 115",
  "Ruta 116",
  "Túnel Fervergal",
  "Pueblo Azuliza",
  "Ruta 106",
  "Cueva Granito",
  "Ruta 107",
  "Ciudad Portual",
  "Ruta 110",
  "Ruta 117",
  "Ruta 111",
  "Ruta 112",
  "Senda Ígnea",
  "Ruta 113",
  "Ruta 114",
  "Cascada Meteoro",
  "Desfiladero",
  "Pueblo Lavacalda",
  "Ruta 118",
  "Ruta 119",
  "Instituto Meteorológico",
  "Ciudad Arborada",
  "Ruta 120",
  "Ruta 121",
  "Zona Safari",
  "Ciudad Calagua",
  "Ruta 122",
  "Monte Pírico",
  "Ruta 123",
  "Guarida Aqua/Magma",
  "Ruta 124",
  "Ciudad Algaria",
  "Ruta 125",
  "Cueva Cardumen",
  "Ruta 127",
  "Ruta 128",
  "Caverna Abisal",
  "Ruta 126",
  "Arrecípolis",
  "Cueva Ancestral",
  "Ruta 129",
  "Ruta 130",
  "Ruta 131",
  "Pilar Celeste",
  "Pueblo Oromar",
  "Isla Espejismo",
  "Ruta 105",
  "Ruta 108",
  "Malvamar",
  "Ruta 109",
  "Ruta 132",
  "Ruta 133",
  "Ruta 134",
  "Calle Victoria",
];

List<String> sinnohRouteList = [
  "Starter",
  "Pueblo HojaVerde",
  "Ruta 201",
  "Lago Veraz",
  "Ruta 219",
  "Ruta 202",
  "Ruta 218",
  "Ruta 204",
  "Ruta 203",
  "Puerta Pirita",
  "Ciudad Pirita",
  "Ruta 207",
  "Mina Pirita",
  "Senda Desolada",
  "Prado Aromaflor",
  "Valle Eólico",
  "Ruta 205",
  "Bosque Vetusto",
  "Ciudad Vetusta",
  "Ruta 211",
  "Ruta 206",
  "Cueva Extravío",
  "Monte Corona",
  "Ruta 208",
  "Ciudad Corazón",
  "Ruta 209",
  "Torre Perdida",
  "Ruinas Sosiego",
  "Ruta 210",
  "Ruta 215",
  "Ruta 214",
  "Mina Ruinamaníaco",
  "Orilla Valor",
  "Ruta 213",
  "Ciudad Pradera",
  "Gran Pantano",
  "Ruta 212",
  "Mansión Pokémon",
  "Pueblo Caelestis",
  "Forja Fuego",
  "Ruta 220",
  "Ruta 221",
  "Ciudad Canal",
  "Isla Hierro",
  "Lago Valor",
  "Ruta 216",
  "Ruta 217",
  "Orilla Agudeza",
  "Lago Agudeza",
  "Ciudad Puntaneva",
  "Mundo Distorsion",
  "Fuente Despedida",
  "Ruta 222",
  "Ciudad Marina",
  "Ruta 223",
  "Calle Victoria",
];

List<String> teseliaRouteList = [
  "Starter",
  "Pueblo Arcilla",
  "Ruta 1",
  "Ruta 2",
  "Ciudad Gres",
  "Solar de los Sueños",
  "Ruta 3",
  "Cueva Manantial",
  "Ciudad Esmalte",
  "Bosque Azulejo",
  "Ciudad Porcelana",
  "Ruta 4",
  "Zona Desierto",
  "Castillo Ancestral",
  "Ruta 5",
  "Puente de Fayenza",
  "Ciudad Fayenza",
  "Almacenes Frigoríficos",
  "Ruta 6",
  "Cueva Loza",
  "Cueva Electrorroca",
  "Ruta 7",
  "Torre de los Cielos",
  "Ruta 17",
  "Ruta 18",
  "Monte Tuerca",
  "Ciudad Teja",
  "Torre Duodraco",
  "Ruta 8",
  "Pantano Teja",
  "Ruta 9",
  "Ruta 10",
  "Calle Victoria",
];

List<String> kalosRouteList = [
  "Starter",
  "Ruta 2",
  "Bosque de Novarte",
  "Ruta 3",
  "Ciudad Novarte",
  "Ruta 22",
  "Ruta 4",
  "Ciudad Luminalia",
  "Ruta 5",
  "Pueblo Vánitas",
  "Ruta 6",
  "Palacio Cénit",
  "Ruta 7",
  "Gruta Tierraunida",
  "Ruta 8",
  "Pueblo Petroglifo",
  "Ruta 9",
  "Cueva Brillante",
  "Ciudad Relieve",
  "Ruta 10",
  "Ruta 11",
  "Cueva Reflejos",
  "Ciudad Yantra",
  "Torre Maestra",
  "Ruta 12",
  "Bahía Azul",
  "Ruta 13",
  "Ruta 14",
  "Ciudad Romantis",
  "Ruta 15",
  "Hotel Desolación",
  "Gruta Helada",
  "Ruta 17",
  "Ruta 18",
  "Cueva Desenlace",
  "Pueblo Mosaico",
  "Ruta 19",
  "Ciudad Fractal",
  "Ruta 20",
  "Villa Pokémon",
  "Ruta 21",
  "Calle Victoria",
];

List<String> alolaRouteList = [
  "Starter",
  "Afueras de Hauoli",
  "Ruta 1",
  "Escuela de entrenadores",
  "Ciudad Hauoli",
  "Ruta 2",
  "Cueva Sotobosque",
  "Cementerio de Hauoli",
  "Ruta 3",
  "Jardines de Melemele",
  "Gruta Unemar",
  "Bahía Kalae",
  "Colina Dequilate",
  "Ruat 4",
  "Pueblo Ohana",
  "Rancho Ohana",
  "Ruta 5",
  "Colina Saltagua",
  "Mar de Melemele",
  "Ruta 6",
  "Ruta 7",
  "Área Volcánica del Wela",
  "Ruta 8",
  "Jungla Umbría",
  "Ciudad Konikoni",
  "Túnel Diglett",
  "Ruta 9",
  "Colina del Recuerdo",
  "Afueras de Akala",
  "Playa de Hanohano",
  "Ciudad Malíe",
  "Parque de Malíe",
  "Ruta 10",
  "Pico Hokulani",
  "Ruta 11",
  "Ruta 12",
  "Playa Menor",
  "Monte Rubor",
  "Ruta 13",
  "Aldea Tapu",
  "Ruta 14",
  "Ruta 15",
  "Supermercado Ultraganga",
  "Ruta 16",
  "Jardines de Ula-Ula",
  "Ruta 17",
  "Aldea Marina",
  "Prado de Poni",
  "Antiguo Paso de Poni",
  "Arrecife de Poni",
  "Isla Exeggutor",
  "Cañón de Poni",
  "Altar del Sol/de la Luna",
  "Monte Lanakila",
];

List<String> galarRouteList = [
  "Starter",
  "Bosque Oniria",
  "Ruta 1",
  "Pueblo Par",
  "Ruta 2",
  "Estación Área Silvestre",
  "Área Silvestre: Pradera Radiante",
  "Área Silvestre: Arboleda Claroscuro",
  "Área Silvestre: Lago Axew (oeste)",
  "Área Silvestre: Lago Axew (este)",
  "Área Silvestre: Lago Milotic (norte)",
  "Área Silvestre: Lago Milotic (sur)",
  "Área Silvestre: Antigua Atalaya",
  "Área Silvestre: Silla del Gigante",
  "Área Silvestre: Ojo de Axew",
  "Ciudad Pistón",
  "Ruta 3",
  "Mina de Galar",
  "Ruta 4",
  "Pueblo Hoyuelo",
  "Ruta 5",
  "Pueblo Amura",
  "Mina de Galar nº 2",
  "Afueras de Pistón",
  "Área Silvestre: Ribera de Pistón",
  "Área Silvestre: Valle Entrepuentes",
  "Área Silvestre: Llanura Pétrea",
  "Área Silvestre: Cuenca Polvorienta",
  "Área Silvestre: Cornisa de Artejo",
  "Área Silvestre: Gorro del Gigante",
  "Área Silvestre: Espejo del Gigante",
  "Área Silvestre: Lago del Enfado",
  "Ciudad Artejo",
  "Ruta 6",
  "Pueblo Ladera",
  "Bosque Lumirinto",
  "Pueblo Plié",
  "Ruta 7",
  "Ruta 8",
  "Pueblo Auriga",
  "Ruta 9",
  "Pueblo Crampón",
  "Ruta 10",
  "Ciudad Puntera",
  "Estadio Artejo",
];

List<List<String>> regionRouteList = [
  kantoRouteList,
  johtoRouteList,
  hoennRouteList,
  sinnohRouteList,
  teseliaRouteList,
  kalosRouteList,
  alolaRouteList,
  galarRouteList,
];

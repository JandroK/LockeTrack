import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Pokedex {
  final List<Pokemon> pokemons;

  Pokedex({required this.pokemons});

  factory Pokedex.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['pokedex'] as List;
    List<Pokemon> pokemonList = list.map((i) => Pokemon.fromJson(i)).toList();
    return Pokedex(pokemons: pokemonList);
  }
}

class Pokemon {
  final String numberDex;
  final String name;
  final List<String> types;
  //bool shiny = false;
  //bool cath = false;

  Pokemon({required this.numberDex, required this.name, required this.types});

  factory Pokemon.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['type'];
    List<String> typesList = List<String>.from(list);
    return Pokemon(
        numberDex: getNumberDex(parsedJson['id']),
        name: parsedJson['name']['english'],
        types: typesList);
  }

  Pokemon.fromFireBase(Map<String, dynamic> doc)
      : numberDex = doc['number_dex'],
        name = doc['name'],
        types = [doc['type1'], doc['type2']];
}

String getNumberDex(int number) {
  String numberDex = "#";
  if (number < 10) {
    numberDex += "00" + number.toString();
  } else if (number < 100) {
    numberDex += "0" + number.toString();
  } else {
    numberDex += number.toString();
  }
  return numberDex;
}

bool equalsIgnoreCase(String string1, String string2) {
  return string1.toLowerCase().contains(string2.toLowerCase());
}

Future<String> loadPokedexJSON() async {
  return await rootBundle.loadString('assets/pokedex.json');
}

Future<List<Pokemon>> loadPokedex() async {
  String jsonString = await loadPokedexJSON();
  final jsonResponse = json.decode(jsonString);
  Pokedex pokedex = Pokedex.fromJson(jsonResponse);
  return pokedex.pokemons;
}

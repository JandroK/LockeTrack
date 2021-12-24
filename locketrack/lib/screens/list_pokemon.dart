import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:locketrack/custom_classes/pokedex.dart';

// global variable
bool search = false;

class Pokedex extends StatefulWidget {
  Pokedex({
    Key? key,
  }) : super(key: key);

  @override
  State<Pokedex> createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  final db = FirebaseFirestore.instance.collection("pokemons");
  List<String> pokemonsID = [];
  List<Color> paletteColors = [];
  late TextEditingController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generatePokemons(db);
    controller = TextEditingController(text: "");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void paletteGenerator(String path) async {
    if (path != "000") {
      await PaletteGenerator.fromImageProvider(
        AssetImage("assets/sprites/$path.png"),
        maximumColorCount: 25,
      ).then((value) {
        paletteColors.add(value.dominantColor!.color);
      });
    }
    setState(() {});
  }

  void generatePokemons(CollectionReference<Map<String, dynamic>> collection) {
    collection.get().then((value) {
      if (value.size == 1) {
        loadPokedex().then((value) {
          value.forEach((element) async {
            await collection.add({
              'number_dex': element.numberDex,
              'name': element.name,
              'type1': element.types[0],
              'type2': (element.types.length > 1) ? element.types[1] : "",
            });
          });
        });
      }
    }).then((value) => loadPokemons());
  }

  void loadPokemons() async {
    await db.orderBy("number_dex").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        pokemonsID.add(result.id);
        paletteGenerator(result.data()["number_dex"].toString().substring(1));
      });
    }).then((value) => pokemonsID.remove(pokemonsID[0]));
    setState(() {
      print("Load pokemons id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokédex"),
        actions: [
          IconButton(
            icon: Icon((search == false)
                ? Icons.search_rounded
                : Icons.search_off_rounded),
            onPressed: () {
              setState(() {
                search = !search;
              });
            },
          )
        ],
      ),
      body: (pokemonsID.isEmpty || paletteColors.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (search)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                    child: Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: TextField(
                            controller: controller,
                            cursorColor: Colors.orange,
                            decoration: const InputDecoration(
                              hintText: "Pokémon Name",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            ),
                          ),
                        ),
                      ),
                      OutlinedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text("Search",
                              style: TextStyle(color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                              minimumSize: const Size(55, 30),
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              side: const BorderSide(color: Colors.white54),
                              backgroundColor: Colors.orange))
                    ]),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: pokemonsID.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PokemonSnapshot(
                          db: db.doc(pokemonsID[index]),
                          color: paletteColors[index],
                          findPokemon: controller.text);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class PokemonSnapshot extends StatelessWidget {
  final String findPokemon;
  final Color color;
  const PokemonSnapshot({
    required this.findPokemon,
    required this.color,
    required this.db,
    Key? key,
  }) : super(key: key);

  final DocumentReference<Map<String, dynamic>> db;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final doc = snapshot.data!.data();
        if (doc != null) {
          return PokemonInfo(
            pokemonInfo: Pokemon.fromFireBase(doc),
            color: color,
            findPokemon: findPokemon,
          );
        } else {
          return const Center(child: Text("doc is null!"));
        }
      },
    );
  }
}

class PokemonInfo extends StatefulWidget {
  final Pokemon pokemonInfo;
  final Color color;
  final String findPokemon;
  const PokemonInfo({
    required this.pokemonInfo,
    required this.color,
    required this.findPokemon,
    Key? key,
  }) : super(key: key);

  @override
  State<PokemonInfo> createState() => _PokemonInfoState();
}

class _PokemonInfoState extends State<PokemonInfo> {
  bool cath = false;
  bool shiny = false;

  Expanded containerType(String type) {
    return Expanded(
      child: Container(
        child: Text(type,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black.withAlpha(150))),
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: Colors.black.withAlpha(150), width: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if ((search &&
            equalsIgnoreCase(widget.pokemonInfo.name, widget.findPokemon)) ||
        !search) {
      return Card(
        margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
        child: ElevatedButton(
          onPressed: () {
            print(widget.pokemonInfo.name);
          },
          // Probar a hacer un degradado segun los tipos
          style: ElevatedButton.styleFrom(primary: widget.color),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            widget.pokemonInfo.numberDex,
                            style:
                                TextStyle(color: Colors.black.withAlpha(150)),
                          ),
                          const SizedBox(width: 20),
                          Text(widget.pokemonInfo.name,
                              style: TextStyle(
                                  color: Colors.black.withAlpha(150))),
                          const Spacer(),
                          IconButton(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(0),
                            constraints: const BoxConstraints(maxHeight: 34),
                            icon: Icon(
                                (shiny)
                                    ? Icons.star_rate_rounded
                                    : Icons.star_border_rounded,
                                color: Colors.black.withAlpha(150)),
                            onPressed: () {
                              setState(() {
                                shiny = !shiny;
                              });
                            },
                          ),
                          Checkbox(
                            activeColor: Colors.black.withAlpha(150),
                            side: BorderSide(
                                color: Colors.black.withAlpha(150), width: 2),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: cath,
                            onChanged: (value) {
                              setState(() {
                                cath = !cath;
                              });
                            },
                            shape: const CircleBorder(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          containerType(widget.pokemonInfo.types[0]),
                          if (widget.pokemonInfo.types[1] != "")
                            containerType(widget.pokemonInfo.types[1]),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 10, top: 8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white38,
                    ),
                    child: Image.asset(
                        "assets/sprites/${widget.pokemonInfo.numberDex.substring(1)}.png"),
                    height: 75)
              ],
            ),
          ),
        ),
      );
    }
    return const Center();
  }
}

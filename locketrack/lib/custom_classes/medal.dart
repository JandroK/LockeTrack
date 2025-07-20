List<Medal> kantoMedalList = [
  Medal("Boulder", 14),
  Medal("Cascade", 21),
  Medal("Thunder", 24),
  Medal("Rainbow", 29),
  Medal("Soul", 43),
  Medal("Marsh", 43),
  Medal("Volcano", 47),
  Medal("Earth", 50),
];
List<Medal> johtoMedalList = [
  Medal("Zephyr", 9),
  Medal("Hive", 16),
  Medal("Plain", 20),
  Medal("Fog", 25),
  Medal("Storm", 30),
  Medal("Mineral", 35),
  Medal("Glacier", 31),
  Medal("Rising", 40),
];
List<Medal> hoennMedalList = [
  Medal("Stone", 15),
  Medal("Knuckle", 18),
  Medal("Dynamo", 23),
  Medal("Heat", 28),
  Medal("Balance", 31),
  Medal("Feather", 34),
  Medal("Mind", 42),
  Medal("Rain", 43),
];
List<Medal> sinnohMedalList = [
  Medal("Coal", 14),
  Medal("Forest", 22),
  Medal("Cobble", 30),
  Medal("Fen", 30),
  Medal("Relic", 36),
  Medal("Mine", 39),
  Medal("Icicle", 42),
  Medal("Beacon", 49),
];
List<Medal> teseliaMedalList = [
  Medal("Trio", 14),
  Medal("Basic", 20),
  Medal("Insect", 23),
  Medal("Bolt", 27),
  Medal("Quake", 31),
  Medal("Jet", 35),
  Medal("Freeze", 39),
  Medal("Legend", 43),
];
List<Medal> kalosMedalList = [
  Medal("Bug", 12),
  Medal("Cliff", 25),
  Medal("Rumble", 32),
  Medal("Plant", 34),
  Medal("Voltage", 37),
  Medal("Fairy", 42),
  Medal("Psychic", 48),
  Medal("Iceberg", 59),
];
List<Medal> alolaMedalList = [
  Medal("Normastal", 12),
  Medal("Lizastal", 15),
  Medal("Hidrostal", 20),
  Medal("Pirostal", 22),
  Medal("Fitostal", 24),
  Medal("Litostal", 27),
  Medal("Electrostal", 29),
  Medal("Metalostal", 31),
  Medal("Espectrostal", 33),
  Medal("Insectostal", 37),
  Medal("Nictostal", 39),
  Medal("Dracostal", 45),
  Medal("Geostal", 48),
  Medal("Feeristal", 55),
  Medal("Toxistal", 61),
  Medal("Criostal", 0),
  Medal("Psicostal", 0),
  Medal("Aerostal", 0),
];
List<Medal> galarMedalList = [
  Medal("Grass", 20),
  Medal("Water", 24),
  Medal("Fire", 27),
  Medal("Fighting", 36),
  Medal("Fairy1", 38),
  Medal("Rock", 42),
  Medal("Dark", 46),
  Medal("Dragon", 48),
];

List<List<Medal>> regionMedalList = [
  kantoMedalList,
  johtoMedalList,
  hoennMedalList,
  sinnohMedalList,
  teseliaMedalList,
  kalosMedalList,
  alolaMedalList,
  galarMedalList,
];

class Medal {
  String name = "";
  int lvl = 0;
  Medal(String name, int lvl) {
    // ignore: prefer_initializing_formals
    this.name = name;
    // ignore: prefer_initializing_formals
    this.lvl = lvl;
  }
}

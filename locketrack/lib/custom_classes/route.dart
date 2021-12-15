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

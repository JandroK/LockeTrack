class Medal {
  bool gained;
  // ignore: non_constant_identifier_names
  String image_default;
  // ignore: non_constant_identifier_names
  String image_gained;
  Medal(
      [this.gained = false,
      this.image_default = "assets/boulder_badge1.png",
      this.image_gained = "assets/boulder_badge0.png"]);
}

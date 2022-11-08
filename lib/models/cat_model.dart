class Cat {
  //int id
  final int? id;
  final String race;
  final String name;
  final String imagepath;

  Cat(
      {this.id,
      required this.race,
      required this.name,
      required this.imagepath});

  factory Cat.fromMap(Map<String, dynamic> json) => Cat(
      id: json['id'],
      race: json['race'],
      name: json['name'],
      imagepath: json['imagepath']);

  Map<String, dynamic> toMap() {
    return {'id': id, 'race': race, 'name': name, 'imagepath': imagepath};
  }
}

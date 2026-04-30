class Cat {
  int? id;
  String name;
  String age;
  String weight;
  String vaccinesJson;
  String appointmentsJson;

  Cat({
    this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.vaccinesJson,
    required this.appointmentsJson,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'vaccines': vaccinesJson,
      'appointments': appointmentsJson,
    };
  }

  factory Cat.fromMap(Map<String, dynamic> map) {
    return Cat(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      weight: map['weight'],
      vaccinesJson: map['vaccines'],
      appointmentsJson: map['appointments'],
    );
  }
}
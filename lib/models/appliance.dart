class Appliance {
  final String id;
  final String name;
  final String place;
  final double useTime;
  final String frequency;
  final String description;
  final String user;

  Appliance({
    required this.id,
    required this.name,
    required this.place,
    required this.useTime,
    required this.frequency,
    required this.description,
    required this.user,
  });

  factory Appliance.fromJson(Map<String, dynamic> json) {
    return Appliance(
      id: json['id'],
      name: json['name'],
      place: json['place'],
      useTime: json['useTime'],
      frequency: json['frequency'],
      description: json['description'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'place': place,
        'useTime': useTime,
        'frequency': frequency,
        'description': description,
        'user': user,
      };
}

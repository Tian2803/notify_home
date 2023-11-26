// company.dart

class Experto {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String deviceId;

  Experto(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.deviceId});

  factory Experto.fromJson(Map<String, dynamic> json) {
    return Experto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      deviceId: json['deviceId']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'deviceId':deviceId
      };

  String getUserName() {
    return name;
  }
}

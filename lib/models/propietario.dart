// company.dart

class Propietario {
  final String id;
  final String name;
  final String address;
  final String email;
  final String phone;
  final String deviceId;

  Propietario({
    required this.id,
    required this.name,
    required this.address, 
    required this.email, 
    required this.phone,
    required this.deviceId
  });

  factory Propietario.fromJson(Map<String, dynamic> json) {
    return Propietario(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
      deviceId: json['deviceId']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'name': name,
        'email': email,
        'phone': phone,
        'deviceId':deviceId
      };

  String getUserName() {
    return name;
  }
}

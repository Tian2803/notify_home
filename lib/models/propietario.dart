// company.dart

class Propietario {
  final String id;
  final String name;
  final String address;
  final String email;
  final String phone;

  Propietario({
    required this.id,
    required this.name,
    required this.address, 
    required this.email, 
    required this.phone
  });

  factory Propietario.fromJson(Map<String, dynamic> json) {
    return Propietario(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'name': name,
        'email': email,
        'phone': phone,
      };

  String getUserName() {
    return name;
  }
}

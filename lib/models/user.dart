// company.dart

class Usuario {
  final String id;
  final String name;
  final String address;
  final String email;
  final String phone;

  Usuario({
    required this.id,
    required this.name,
    required this.address, 
    required this.email, 
    required this.phone
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
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

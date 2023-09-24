// company.dart

class Experto {
  final String id;
  final String name;
  final String email;
  final String phone;

  Experto({
    required this.id,
    required this.name, 
    required this.email, 
    required this.phone
  });

  factory Experto.fromJson(Map<String, dynamic> json) {
    return Experto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
      };

  String getUserName() {
    return name;
  }
}

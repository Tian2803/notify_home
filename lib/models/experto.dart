// company.dart

// Clase para representar un experto
class Experto {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String deviceId;

  // Constructor para inicializar un objeto Experto
  Experto({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.deviceId,
  });

  // Constructor de fábrica para crear un objeto Experto desde un mapa JSON
  factory Experto.fromJson(Map<String, dynamic> json) {
    return Experto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      deviceId: json['deviceId'],
    );
  }

  // Método para convertir un objeto Experto a un mapa JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'deviceId': deviceId,
      };
}

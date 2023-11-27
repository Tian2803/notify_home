// Clase para representar a un propietario
class Propietario {
  final String id;
  final String name;
  final String address;
  final String email;
  final String phone;
  final String deviceId;

  // Constructor para inicializar un objeto Propietario
  Propietario({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.deviceId,
  });

  // Constructor de fábrica para crear un objeto Propietario desde un mapa JSON
  factory Propietario.fromJson(Map<String, dynamic> json) {
    return Propietario(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
      deviceId: json['deviceId'],
    );
  }

  // Método para convertir un objeto Propietario a un mapa JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'name': name,
        'email': email,
        'phone': phone,
        'deviceId': deviceId,
      };

}

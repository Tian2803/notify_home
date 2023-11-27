// Clase para representar un electrodoméstico
class Electrodomestico {
  final String id;
  final String name;
  final String fabricante;
  final String modelo;
  final String calificacionEnergetica;
  final String expertoId;
  final String user;

  // Constructor para inicializar un objeto Electrodomestico
  Electrodomestico({
    required this.id,
    required this.name,
    required this.fabricante,
    required this.modelo,
    required this.calificacionEnergetica,
    required this.expertoId,
    required this.user,
  });

  // Constructor de fábrica para crear un objeto Electrodomestico desde un mapa JSON
  factory Electrodomestico.fromJson(Map<String, dynamic> json) {
    return Electrodomestico(
      id: json['id'],
      name: json['name'],
      fabricante: json['fabricante'],
      modelo: json['modelo'],
      calificacionEnergetica: json['calificacionEnergetica'],
      expertoId: json['expertoId'],
      user: json['user'],
    );
  }

  // Método para convertir un objeto Electrodomestico a un mapa JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'fabricante': fabricante,
        'modelo': modelo,
        'calificacionEnergetica': calificacionEnergetica,
        'expertoId': expertoId,
        'user': user,
      };
}

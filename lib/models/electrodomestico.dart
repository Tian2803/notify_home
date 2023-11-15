class Electrodomestico {
  final String id;
  final String name;
  final String fabricante;
  final String modelo;
  final String calificacionEnergetica;
  final String expertoId;
  final String user;

  Electrodomestico({
    required this.id,
    required this.name,
    required this.fabricante,
    required this.modelo,
    required this.calificacionEnergetica,
    required this.expertoId,
    required this.user,
  });

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

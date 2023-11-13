class Electrodomestico {
  final String id;
  final String name;
  final String fabricante;
  final String modelo;
  final String tipo;
  final String expertoId;
  final String user;

  Electrodomestico({
    required this.id,
    required this.name,
    required this.fabricante,
    required this.modelo,
    required this.tipo,
    required this.expertoId,
    required this.user,
  });

  factory Electrodomestico.fromJson(Map<String, dynamic> json) {
    return Electrodomestico(
      id: json['id'],
      name: json['name'],
      fabricante: json['fabricante'],
      modelo: json['modelo'],
      tipo: json['tipo'],
      expertoId: json['expertoId'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'fabricante': fabricante,
        'modelo': modelo,
        'tipo': tipo,
        'expertoId': expertoId,
        'user': user,
      };
}

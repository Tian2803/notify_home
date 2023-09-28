class Appliance {
  final String id;
  final String name;
  final String fabricante;
  final String marca;
  final String modelo;
  final String tipo;
  final String user;

  Appliance({
    required this.id,
    required this.name,
    required this.fabricante,
    required this.marca,
    required this.modelo,
    required this.tipo,
    required this.user,
  });

  factory Appliance.fromJson(Map<String, dynamic> json) {
    return Appliance(
      id: json['id'],
      name: json['name'],
      fabricante: json['fabricante'],
      marca: json['marca'],
      modelo: json['modelo'],
      tipo: json['tipo'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'fabricante': fabricante,
        'marca': marca,
        'modelo': modelo,
        'tipo': tipo,
        'user': user,
      };
}

// Clase para representar la hoja de vida de un electrodoméstico
class HojaVidaElectrodomestico {
  final String id;
  final String condicionAmbiental;
  final DateTime fechaCompra;
  final DateTime fechaInstalacion;
  final DateTime fechaUltMantenimiento;
  final int tiempoUso;
  final String frecuenciaUso;
  final String ubicacion;
  final String user;

  // Constructor para inicializar un objeto HojaVidaElectrodomestico
  HojaVidaElectrodomestico({
    required this.id,
    required this.condicionAmbiental,
    required this.fechaCompra,
    required this.fechaInstalacion,
    required this.fechaUltMantenimiento,
    required this.tiempoUso,
    required this.frecuenciaUso,
    required this.ubicacion,
    required this.user,
  });

  // Constructor de fábrica para crear un objeto HojaVidaElectrodomestico desde un mapa JSON
  factory HojaVidaElectrodomestico.fromJson(Map<String, dynamic> json) {
    return HojaVidaElectrodomestico(
      id: json['id'],
      condicionAmbiental: json['condicionAmbiental'],
      fechaCompra: DateTime.parse(json['fechaCompra']),
      fechaInstalacion: DateTime.parse(json['fechaInstalacion']),
      fechaUltMantenimiento: DateTime.parse(json['fechaUltMantenimiento']),
      tiempoUso: json['tiempoUso'],
      frecuenciaUso: json['frecuenciaUso'],
      ubicacion: json['ubicacion'],
      user: json['user'],
    );
  }

  // Método para convertir un objeto HojaVidaElectrodomestico a un mapa JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'condicionAmbiental': condicionAmbiental,
        'fechaCompra': fechaCompra.toIso8601String(),
        'fechaInstalacion': fechaInstalacion.toIso8601String(),
        'fechaUltMantenimiento': fechaUltMantenimiento.toIso8601String(),
        'tiempoUso': tiempoUso,
        'frecuenciaUso': frecuenciaUso,
        'ubicacion': ubicacion,
        'user': user,
      };
}

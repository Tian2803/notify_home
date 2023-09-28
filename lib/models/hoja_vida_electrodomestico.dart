class HojaVidaElectrodomestico {
  final String id;
  final String condicionAmbiental;
  final DateTime fechaCompra;
  final DateTime fechaInstalacion;
  final DateTime fechaMManual;
  final DateTime fechaUltMantenimiento;
  final int tiempoUso;
  final String frecuenciaUso;
  final String ubicacion;
  final String user;

  HojaVidaElectrodomestico({
    required this.id,
    required this.condicionAmbiental,
    required this.fechaCompra,
    required this.fechaInstalacion,
    required this.fechaMManual,
    required this.fechaUltMantenimiento,
    required this.tiempoUso,
    required this.frecuenciaUso,
    required this.ubicacion,
    required this.user,
  });

  factory HojaVidaElectrodomestico.fromJson(Map<String, dynamic> json) {
    return HojaVidaElectrodomestico(
      id: json['id'],
      condicionAmbiental: json['condicionAmbiental'],
      fechaCompra: json['fechaCompra'],
      fechaInstalacion: json['fechaInstalacion'],
      fechaMManual: json['fechaMManual'],
      fechaUltMantenimiento: json['fechaUltMantenimiento'],
      tiempoUso: json['tiempoUso'],
      frecuenciaUso: json['frecuenciaUso'],
      ubicacion: json['ubicacion'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'condicionAmbiental': condicionAmbiental,
        'fechaCompra': fechaCompra.toIso8601String(),
        'fechaInstalacion': fechaInstalacion.toIso8601String(),
        'fechaMManual': fechaMManual.toIso8601String(),
        'fechaUltMantenimiento': fechaUltMantenimiento.toIso8601String(),
        'tiempoUso': tiempoUso,
        'frecuenciaUso': frecuenciaUso,
        'ubicacion': ubicacion,
        'user': user,
      };
}

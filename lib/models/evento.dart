class Evento {
  final String id;
  final String titulo;
  final int anho;
  final int mes;
  final int dia;
  final String electrodomesticoId;
  final int prioridad;

  Evento(
      {required this.titulo,
      this.id = '',
      this.anho = 0,
      this.mes = 0,
      this.dia = 0,
      this.electrodomesticoId = '',
      this.prioridad = 0});

  @override
  String toString() => titulo;
}

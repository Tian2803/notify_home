import 'package:cloud_firestore/cloud_firestore.dart';

// Clase para representar un evento
class Evento {
  final String id;
  final String titulo;
  final DateTime date;
  final String electrodomesticoId;
  final int prioridad;
  final String userId;

  // Constructor para inicializar un objeto Evento
  Evento({
    required this.titulo,
    required this.id,
    required this.date,
    required this.electrodomesticoId,
    required this.prioridad, 
    required this.userId,
  });

  // Constructor de fábrica para crear un objeto Evento desde un mapa JSON
  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      titulo: json['titulo'],
      id: json['id'],
      date: (json['date'] as Timestamp).toDate(),
      electrodomesticoId: json['electrodomesticoId'],
      prioridad: json['prioridad'],
      userId: json['userId'],
    );
  }

  // Método para convertir un objeto Evento a un mapa JSON
  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'id': id,
        'date': Timestamp.fromDate(date),
        'electrodomesticoId': electrodomesticoId,
        'prioridad': prioridad,
        'userId': userId,
      };
}

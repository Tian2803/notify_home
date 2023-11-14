import 'package:cloud_firestore/cloud_firestore.dart';

class Evento {
  final String id;
  final String titulo;
  final DateTime date;
  final String electrodomestico;
  final int prioridad;
  final String userId;

  Evento(
      {
      required this.titulo,
      required this.id,
      required this.date,
      required this.electrodomestico,
      required this.prioridad, 
      required this.userId});

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
        titulo: json['titulo'],
        id: json['id'],
        date: (json['date']  as Timestamp).toDate(),
        electrodomestico: json['electrodomestico'],
        prioridad: json['prioridad'],
        userId: json['userId']);
  }

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'id': id,
        'date': Timestamp.fromDate(date),
        'electrodomestico': electrodomestico,
        'prioridad': prioridad,
        'userId': userId
      };

}


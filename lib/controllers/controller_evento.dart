import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notify_home/models/evento.dart';

Future<List<Evento>> loadEventsForUser(String uid) async {
  final collection = FirebaseFirestore.instance.collection('eventos');
  final snapshot = await collection.where('userID', isEqualTo: uid).get();

  final events = <Evento>[];
  for (final doc in snapshot.docs) {
    final data = doc.data();
    final event = Evento(
      id: doc.id,
      titulo: data['titulo'],
      anho: data['anho'] as int,
      mes: data['mes'] as int,
      dia: data['dia'] as int,
      electrodomesticoId: data['electrodomesticoId'],
      prioridad: data['prioridad'],
    );
    events.add(event);
  }

  return events;
}

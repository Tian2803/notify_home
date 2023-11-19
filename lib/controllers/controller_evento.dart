// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/controller_auxiliar.dart';
import 'package:notify_home/models/evento.dart';

Future<List<Evento>> getEventsForUser(String uid) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot snapshot = await firestore
        .collection('evento')
        .where('userID', isEqualTo: uid)
        .get();

    List<Evento> eventos = [];
    for (var data in snapshot.docs) {
      eventos.add(Evento(
          id: data.id,
          titulo: data['titulo'],
          date: DateTime.parse(data['date']),
          electrodomestico: data['electrodomestico'],
          prioridad: data['prioridad'] as int,
          userId: data['userId']));
    }
    return eventos;
  } catch (e) {
    throw Exception('No se pudo obtener la información de los eventos.');
  }
}

Future<void> registroEvento(BuildContext context, String titulo, int prioridad,
    String electrodomestico, String date) async {
  String id = generateId();

  try {
    if (titulo.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, llene todos los campos',
          AlertMessageType.warning);
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;

    Evento evento = Evento(
        titulo: titulo,
        id: id,
        date: DateTime.parse(date),
        electrodomestico: electrodomestico,
        prioridad: prioridad,
        userId: uid);

    await FirebaseFirestore.instance
        .collection('evento')
        .doc(id)
        .set(evento.toJson());

  } catch (e) {
    showPersonalizedAlert(context, 'Error al registrar el evento',
        AlertMessageType.error);
  }
}

void deleteEvento(Evento evento) {
  DocumentReference eventoRef = FirebaseFirestore.instance
      .collection('evento')
      .doc(evento.id);

  eventoRef.delete().then((doc) {
  }).catchError((error) {
  });
}



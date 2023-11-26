// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/controller_auxiliar.dart';
import 'package:notify_home/controllers/controller_propietario.dart';
import 'package:notify_home/controllers/service_notification.dart';
import 'package:notify_home/models/evento.dart';

Future<void> obtenerYMostrarNotificaciones() async {
  
   // final User user = FirebaseAuth.instance.currentUser!;
    final deviceId = await getDeviceId();
    final idUser = await getPropietarioId(deviceId); 
  final QuerySnapshot eventosSnapshot = await FirebaseFirestore.instance
      .collection('evento') // Reemplaza 'eventos' con el nombre de tu colección
      .where('userId', isEqualTo: idUser) // Filtro opcional por usuario
      .get();

  for (var eventoDoc in eventosSnapshot.docs) {
    final Map<String, dynamic> data = eventoDoc.data() as Map<String, dynamic>;

    //'date' es un campo Timestamp en Firestore
    final DateTime fechaEvento = (data['date'] as Timestamp).toDate();

    final Evento evento = Evento(
      id: eventoDoc.id,
      titulo: data['titulo'],
      date: fechaEvento,
      electrodomesticoId: data['electrodomesticoId'],
      prioridad: data['prioridad'] as int,
      userId: data['userId'],
    );

    // Muestra la notificación si la fecha del evento es igual a la fecha actual
    showNotificacion(evento);
  }
}

Future<void> registroEvento(BuildContext context, String titulo, int prioridad,
    String electrodomestico, DateTime date) async {
  String id = generateId();

  try {
    if (titulo.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, llene todos los campos',
          AlertMessageType.warning);
      return;
    }else{
      final uid = FirebaseAuth.instance.currentUser!.uid;

    Evento evento = Evento(
        titulo: titulo,
        id: id,
        date: date,
        electrodomesticoId: electrodomestico,
        prioridad: prioridad,
        userId: uid);

    await FirebaseFirestore.instance
        .collection('evento')
        .doc(id)
        .set(evento.toJson());
    }

    showPersonalizedAlert(context, "Registro exitoso del evento", AlertMessageType.notification);
  } catch (e) {
    showPersonalizedAlert(
        context, 'Error al registrar el evento', AlertMessageType.error);
  }
}

void eliminarEvento(Evento evento) {
  DocumentReference eventoRef =
      FirebaseFirestore.instance.collection('evento').doc(evento.id);

  eventoRef.delete().then((doc) {}).catchError((error) {});
}

void asignarFechaMantenimiento(
    BuildContext context,
    String prioridad,
    DateTime fechaUltimoMantenimiento,
    String nombreElectrodomestico,
    String electrodomesticoId) {
  DateTime fechaMantenimiento;
  int diasHastaMantenimiento;

  switch (prioridad) {
    case 'Alta':
      diasHastaMantenimiento = 30;
      break;
    case 'Moderada':
      diasHastaMantenimiento = 90;
      break;
    default:
      diasHastaMantenimiento = 180;
  }

  fechaMantenimiento =
      fechaUltimoMantenimiento.add(Duration(days: diasHastaMantenimiento));

  Evento evento = Evento(
    id: "",
    userId: "",
    titulo:
        nombreElectrodomestico, //traer nombre de la base de datos('electrodomestico')
    date: fechaMantenimiento,
    electrodomesticoId: electrodomesticoId,
    prioridad: prioridad == 'Alta'
        ? 3
        : prioridad == 'Moderada'
            ? 2
            : 1,
  );

  registroEvento(context, evento.titulo, evento.prioridad,
      evento.electrodomesticoId, evento.date);
}
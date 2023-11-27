// Ignorar advertencias específicas para el archivo
// ignore_for_file: use_build_context_synchronously
// Importación de paquetes y archivos necesarios
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/auxiliar_controller.dart';
import 'package:notify_home/controllers/propietario_controller.dart';
import 'package:notify_home/controllers/service_notification.dart';
import 'package:notify_home/models/evento.dart';

// Función asincrónica para obtener y mostrar notificaciones
Future<void> obtenerYMostrarNotificaciones() async {
  // Obtener el ID del dispositivo y del usuario actual
  final deviceId = await getDeviceId();
  final idUser = await getPropietarioId(deviceId);

  // Consultar eventos en Firestore para el propietario específico
  final QuerySnapshot eventosSnapshot = await FirebaseFirestore.instance
      .collection('evento')
      .where('userId', isEqualTo: idUser)
      .get();

  // Iterar sobre los documentos de eventos
  for (var eventoDoc in eventosSnapshot.docs) {
    final Map<String, dynamic> data = eventoDoc.data() as Map<String, dynamic>;

    // 'date' es un campo Timestamp en Firestore
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

// Función asincrónica para registrar un nuevo evento
Future<void> registroEvento(
    BuildContext context, String titulo, int prioridad, String electrodomestico, DateTime date) async {
  // Generar un ID único para el evento
  String id = generateId();

  try {
    // Validar que el título no esté vacío
    if (titulo.isEmpty) {
      showPersonalizedAlert(
          context, 'Por favor, llene todos los campos', AlertMessageType.warning);
      return;
    } else {
      // Obtener el ID del usuario actual
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Crear un objeto Evento con los datos proporcionados
      Evento evento = Evento(
        titulo: titulo,
        id: id,
        date: date,
        electrodomesticoId: electrodomestico,
        prioridad: prioridad,
        userId: uid,
      );

      // Guardar el nuevo evento en Firestore
      await FirebaseFirestore.instance.collection('evento').doc(id).set(evento.toJson());
    }

    // Mostrar una alerta de éxito
    showPersonalizedAlert(context, "Registro exitoso del evento", AlertMessageType.notification);
  } catch (e) {
    // Mostrar una alerta en caso de error
    showPersonalizedAlert(context, 'Error al registrar el evento', AlertMessageType.error);
  }
}

// Función para eliminar un evento
void eliminarEvento(Evento evento) {
  // Obtener una referencia al documento del evento en Firestore
  DocumentReference eventoRef = FirebaseFirestore.instance.collection('evento').doc(evento.id);

  // Eliminar el evento
  eventoRef.delete().then((doc) {}).catchError((error) {});
}

// Función para asignar una fecha de mantenimiento basada en la prioridad
void asignarFechaMantenimiento(
    BuildContext context,
    String prioridad,
    DateTime fechaUltimoMantenimiento,
    String nombreElectrodomestico,
    String electrodomesticoId) {
  // Inicializar variables para la fecha de mantenimiento y los días hasta el mantenimiento
  DateTime fechaMantenimiento;
  int diasHastaMantenimiento;

  // Calcular los días hasta el próximo mantenimiento basado en la prioridad
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

  // Calcular la fecha de mantenimiento sumando los días hasta el mantenimiento a la última fecha de mantenimiento
  fechaMantenimiento = fechaUltimoMantenimiento.add(Duration(days: diasHastaMantenimiento));

  // Crear un nuevo evento con la fecha de mantenimiento calculada
  Evento evento = Evento(
    id: "",
    userId: "",
    titulo: nombreElectrodomestico,
    date: fechaMantenimiento,
    electrodomesticoId: electrodomesticoId,
    prioridad: prioridad == 'Alta'
        ? 3
        : prioridad == 'Moderada'
            ? 2
            : 1,
  );

  // Registrar el nuevo evento en Firestore
  registroEvento(context, evento.titulo, evento.prioridad, evento.electrodomesticoId, evento.date);
}

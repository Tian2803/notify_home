import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notify_home/models/evento.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const  initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

  Future<void> showNotificacion(Evento evento) async {
  final DateTime fechaActual = DateTime.now();
  final DateTime fechaEvento = evento.date; // Asumo que `date` es un objeto `Timestamp`

  // Compara las fechas
  if (fechaEvento.year == fechaActual.year &&
      fechaEvento.month == fechaActual.month &&
      fechaEvento.day == fechaActual.day) {
    // Las fechas son iguales, muestra la notificación

    // Resto del código para la creación de la notificación
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      evento.id.hashCode, // Usamos el ID del evento como ID único para cada notificación
      evento.titulo,
      'Hoy es el día de mantenimiento de ${evento.titulo}',
      notificationDetails,
    );
  }
}
// Importación de paquetes necesarios
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notify_home/models/evento.dart';

// Creación de una instancia global de FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Función asincrónica para inicializar las notificaciones locales
Future<void> initNotifications() async {
  // Configuración de la inicialización para Android
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // Configuración de la inicialización para iOS
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  // Configuración general de inicialización
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // Inicialización de FlutterLocalNotificationsPlugin con la configuración proporcionada
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Función asincrónica para mostrar una notificación basada en un evento
Future<void> showNotificacion(Evento evento) async {
  // Obtención de la fecha y hora actual
  final DateTime fechaActual = DateTime.now();
  // Obtención de la fecha y hora del evento (asumo que `date` es un objeto `Timestamp`)
  final DateTime fechaEvento = evento.date;

  // Comparación de las fechas
  if (fechaEvento.year == fechaActual.year &&
      fechaEvento.month == fechaActual.month &&
      fechaEvento.day == fechaActual.day) {
    // Las fechas son iguales, muestra la notificación

    // Configuración de detalles de notificación para Android
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    // Configuración general de detalles de notificación
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Mostrar la notificación utilizando FlutterLocalNotificationsPlugin
    await flutterLocalNotificationsPlugin.show(
      evento.id
          .hashCode, // Utilizamos el ID del evento como ID único para cada notificación
      evento.titulo,
      'Hoy es el día de mantenimiento de ${evento.titulo}',
      notificationDetails,
    );
  }
}

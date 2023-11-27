// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/controller_evento.dart';
import 'package:notify_home/controllers/login_controller.dart';
import 'package:notify_home/controllers/service_notification.dart';
import 'firebase_options.dart'; // Asegúrate de que este archivo existe y contiene las configuraciones de Firebase.
import 'package:firebase_core/firebase_core.dart';

// Función principal que se ejecuta al iniciar la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicialización de las notificaciones
  await initNotifications();
  // Inicialización de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Obtención y muestra de notificaciones existentes
  await obtenerYMostrarNotificaciones();
  // Ejecución de la aplicación
  runApp(const MyApp());
}

// Clase principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notify home',
      theme: ThemeData(
        // Definición del esquema de colores de la aplicación
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 37, 43, 214),
        ),
      ),
      // Configuración de la pantalla inicial como la de inicio de sesión
      home: const LoginController(),
    );
  }
}

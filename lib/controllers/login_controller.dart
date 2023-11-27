// Ignorar advertencias específicas para el archivo
// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
// Importación de paquetes y archivos necesarios
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/controlador_experto.dart';
import 'package:notify_home/controllers/controller_evento.dart';
import 'package:notify_home/views/control_acceso_autenticacion/login_view.dart';
import 'package:notify_home/views/vista_principal_experto.dart';
import 'package:notify_home/views/vista_principal_propietario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notify_home/controllers/alert_dialog.dart';

// Definición del widget LoginController como StatefulWidget
class LoginController extends StatefulWidget {
  const LoginController({Key? key}) : super(key: key);

  @override
  _LoginControllerState createState() => _LoginControllerState();
}

// Clase de estado para el widget LoginController
class _LoginControllerState extends State<LoginController> {
  // Controladores para los campos de entrada de correo electrónico y contraseña
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Banderas para la validación de correo electrónico y contraseña (actualmente establecidas en true)
  final bool _isEmailValid = true;
  final bool _isPasswordValid = true;

  // Función para iniciar sesión con correo electrónico y contraseña
  void signInWithEmailAndPassword(String email, String password) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Extracción de la información del usuario autenticado desde la base de datos
      User? user = userCredential.user;
      String userId = user!.uid;

      // Uso de await para esperar a que getExpertoId() se complete
      String? expId = await getExpertoId();

      // Navegación a la vista principal del experto o del usuario según el tipo de usuario
      if (userId == expId) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeViewExpert()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeViewUser()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Manejo de diferentes excepciones de autenticación y muestra de alertas personalizadas
      if (e.code == 'user-not-found') {
        showPersonalizedAlert(
          context,
          'Usuario no encontrado',
          AlertMessageType.warning,
        );
      } else if (e.code == 'wrong-password') {
        showPersonalizedAlert(
          context,
          'Contraseña incorrecta',
          AlertMessageType.warning,
        );
      } else if (e.code == 'invalid-email') {
        showPersonalizedAlert(
          context,
          'El formato del correo electrónico\nno es válido.',
          AlertMessageType.error,
        );
      } else if (e.code == 'user-disabled') {
        showPersonalizedAlert(
          context,
          'Su cuenta está deshabilitada.',
          AlertMessageType.error,
        );
      } else if (e.code == 'network-request-failed') {
        showPersonalizedAlert(
          context,
          'Problema de red durante la autenticación.',
          AlertMessageType.error,
        );
      } else if (e.code == 'too-many-requests') {
        showPersonalizedAlert(
          context,
          'Demasiadas solicitudes desde el\nmismo dispositivo o IP.',
          AlertMessageType.error,
        );
      } else {
        showPersonalizedAlert(context, 'Error al iniciar sesión: ${e.message}',
            AlertMessageType.error);
      }
    }
  }

  // Función para manejar el proceso de inicio de sesión
  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validación de que el correo electrónico y la contraseña no estén vacíos
    if (email.isEmpty || password.isEmpty) {
      showPersonalizedAlert(
        context,
        'Por favor ingrese su correo electrónico y contraseña',
        AlertMessageType.error,
      );
      return;
    }
    // Iniciar sesión con correo electrónico y contraseña
    signInWithEmailAndPassword(email, password);
    // Obtener y mostrar notificaciones
    obtenerYMostrarNotificaciones();
  }

  // Método de construcción para definir la interfaz de usuario del widget LoginController
  @override
  Widget build(BuildContext context) {
    return LoginView(
      emailController: _emailController,
      passwordController: _passwordController,
      isEmailValid: _isEmailValid,
      isPasswordValid: _isPasswordValid,
      loginPressed: _login,
    );
  }

  // Método dispose para liberar recursos cuando el widget ya no se utiliza
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// Ignorar advertencias específicas para el archivo
// ignore_for_file: avoid_print, use_build_context_synchronously
// Importación de paquetes y archivos necesarios
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/auxiliar_controller.dart';
import 'package:notify_home/controllers/login_controller.dart';
import 'package:notify_home/models/propietario.dart';

// Función asincrónica para obtener el nombre del propietario actual
Future<String?> getNombrePropietario() async {
  try {
    final User user = FirebaseAuth.instance.currentUser!;

    final uid = user.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('propietario').doc(uid).get();

    if (userDoc.exists) {
      final userName = userDoc.data()?['name'];
      return userName as String;
    }
    return null;
  } catch (e) {
    throw Exception('No se pudo obtener el nombre del usuario.');
  }
}

// Función para registrar a un nuevo propietario en la base de datos
void registrarPropietario(
  BuildContext context,
  String propietario,
  String direccion,
  String telefono,
  String email,
  String password,
  String passwordConf,
) async {
  try {
    // Validación de campos obligatorios
    if (propietario.isEmpty ||
        direccion.isEmpty ||
        telefono.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        passwordConf.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, complete todos los campos',
          AlertMessageType.warning);
    } else {
      // Validación de formato de correo electrónico y coincidencia de contraseñas
      bool isEmailValid = AuthController.validateEmail(email);
      bool isPasswordValid =
          AuthController.validatePasswords(password, passwordConf);

      if (isEmailValid && isPasswordValid) {
        // Creación de usuario en Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String idUser = userCredential.user!.uid;

        // Obtención del ID de dispositivo
        final deviceId = await getDeviceId();

        // Creación del objeto Propietario
        Propietario usuario = Propietario(
            id: idUser,
            name: propietario,
            address: direccion,
            email: email,
            phone: telefono,
            deviceId: deviceId);

        // Almacenamiento del objeto Propietario en Firestore
        await FirebaseFirestore.instance
            .collection('propietario')
            .doc(idUser)
            .set(usuario.toJson());

        // Mostrar alerta de registro exitoso
        showPersonalizedAlert(
            context, "Registro exitoso", AlertMessageType.notification);

        // Navegación a la pantalla de inicio de sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginController()),
        );
      } else {
        // Mostrar alerta de contraseñas no coincidentes
        showPersonalizedAlert(
            context, "Las contraseñas no coinciden", AlertMessageType.error);
      }
    }
  } on FirebaseAuthException catch (e) {
    // Manejo de excepciones específicas de Firebase Authentication
    if (e.code == 'email-already-in-use') {
      showPersonalizedAlert(
          context,
          'Correo electrónico ya registrado,\ninicia sesión en lugar de registrarse.',
          AlertMessageType.error);
    } else if (e.code == 'invalid-email') {
      showPersonalizedAlert(
          context,
          'El formato del correo electrónico\nno es válido.',
          AlertMessageType.error);
    } else if (e.code == 'operation-not-allowed') {
      showPersonalizedAlert(
          context,
          'La operación de registro no está\npermitida.',
          AlertMessageType.error);
    } else if (e.code == 'weak-password') {
      showPersonalizedAlert(
          context,
          'La contraseña es débil, debe tener\nal menos 10 caracteres.',
          AlertMessageType.error);
    } else {
      // Mostrar alerta de error general
      showPersonalizedAlert(
          context,
          'Error al registrar al usuario: ${e.message}',
          AlertMessageType.error);
    }
  }
}

// Función asincrónica para obtener el ID del propietario a partir del ID de dispositivo
Future<String?> getPropietarioId(String idDevice) async {
  final collectionReference = FirebaseFirestore.instance.collection('propietario');
  try {
    QuerySnapshot snapshot =
        await collectionReference.where('deviceId', isEqualTo: idDevice).get();
    if (snapshot.docs.isNotEmpty) {
      // El usuario con el ID de dispositivo proporcionado existe
      final uid = snapshot.docs.first.id; // Suponiendo que hay solo un usuario con ese ID de dispositivo
      return uid;
    }
  } catch (error) {
    print('Error al consultar la base de datos: $error');
  }
  return null;
}

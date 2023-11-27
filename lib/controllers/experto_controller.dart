// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api, unused_element, avoid_print, unrelated_type_equality_checks
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notify_home/controllers/auxiliar_controller.dart';
import 'package:notify_home/controllers/login_controller.dart';
import 'package:notify_home/models/experto.dart';
import 'package:notify_home/controllers/alert_dialog.dart';

// Función para registrar un experto en Firebase Authentication y Firestore
void registrarExperto(String experto, String telefono, String email,
    String password, String passwordConf, BuildContext context) async {
  try {
    // Verifica si algún campo está vacío
    if (experto.isEmpty ||
        telefono.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        passwordConf.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, complete todos los campos',
          AlertMessageType.warning);
    } else {
      // Valida el formato del correo electrónico y las contraseñas
      bool isEmailValid = AuthController.validateEmail(email);
      bool isPasswordValid =
          AuthController.validatePasswords(password, passwordConf);

      if (isEmailValid && isPasswordValid) {
        // Crea un nuevo usuario en Firebase Authentication
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Obtiene el ID del usuario recién creado
        String idUser = FirebaseAuth.instance.currentUser!.uid;
        // Obtiene el ID del dispositivo
        final deviceId = await getDeviceId();

        // Crea un objeto Experto con la información del usuario
        Experto expert = Experto(
            id: idUser,
            name: experto,
            email: email,
            phone: telefono,
            deviceId: deviceId);

        // Almacena la información del experto en Firestore
        await FirebaseFirestore.instance
            .collection('experto')
            .doc(idUser)
            .set(expert.toJson());

        // Muestra una alerta de registro exitoso
        showPersonalizedAlert(
          context,
          "Registro exitoso",
          AlertMessageType.notification,
        );

        // Redirige al usuario a la pantalla de inicio de sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginController()),
        );
      } else {
        // Muestra una alerta si las contraseñas no coinciden o no cumplen con los requisitos
        showPersonalizedAlert(
            context, "Las contraseñas no coinciden", AlertMessageType.error);
      }
    }
  } on FirebaseAuthException catch (e) {
    // Maneja errores específicos de FirebaseAuth
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
      // Muestra una alerta si ocurre otro tipo de error en la autenticación
      showPersonalizedAlert(
          context,
          'Error al registrar al usuario: ${e.message}',
          AlertMessageType.error);
    }
  }
}

// Función para obtener el nombre del usuario experto actual
Future<String?> getNombreUsuarioExperto() async {
  try {
    final User user = FirebaseAuth.instance.currentUser!;

    final uid = user.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('experto').doc(uid).get();

    if (userDoc.exists) {
      final userName = userDoc.data()?['name'];
      return userName as String;
    }
    return null;
  } catch (e) {
    throw Exception('No se pudo obtener el nombre del usuario.');
  }
}

// Función para obtener el ID del experto actual
Future<String?> getExpertoId() async {
  try {
    final User user = FirebaseAuth.instance.currentUser!;

    final uid = user.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('experto').doc(uid).get();

    if (userDoc.exists) {
      final expertId = userDoc.data()?['id'];
      return expertId as String;
    }
    return null;
  } catch (e) {
    throw Exception('No se pudo obtener el identificador del experto.');
  }
}

// Función para obtener la información detallada de todos los expertos
Future<List<Experto>> getExpertoDetalle() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Realiza la consulta a Firebase Firestore
    QuerySnapshot snapshot = await firestore.collection('experto').get();

    // Inicializa una lista para almacenar los expertos
    List<Experto> expertos = [];
    // Recorre los documentos y crea instancias de la clase Experto
    for (var doc in snapshot.docs) {
      expertos.add(Experto(
          id: doc.id,
          name: doc['name'],
          email: doc['email'],
          phone: doc['phone'],
          deviceId: doc['deviceId']));
    }
    // Devuelve la lista de expertos
    return expertos;
  } catch (e) {
    // Maneja errores de forma adecuada
    print('Error, no se logró obtener la información de los expertos: $e');
    throw Exception('No se pudo obtener la información de los expertos.');
  }
}

// Función para filtrar la lista de expertos basándose en el término de búsqueda
List<Experto> filtrarExpertos(List<Experto> expertos, String searchTerm) {
  return expertos.where((expert) {
    return expert.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
        expert.email.toLowerCase().contains(searchTerm.toLowerCase()) ||
        expert.phone.contains(searchTerm);
  }).toList();
}

// Función para obtener el nombre de un experto dado su ID
Future<String> getNombreExperto(String idExperto) async {
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('experto')
        .doc(idExperto)
        .get();

    if (userDoc.exists) {
      final userName = userDoc.data()?['name'];
      print(userName);
      return userName as String;
    } else {
      return "Asigne un experto";
    }
  } catch (e) {
    throw Exception('No se pudo obtener el nombre del usuario.');
  }
}

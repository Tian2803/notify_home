// ignore_for_file: use_build_context_synchronously
//FUNCIONA BIEN
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/controller_auxiliar.dart';
import 'package:notify_home/controllers/login_controller.dart';
import 'package:notify_home/models/user.dart';

Future<String?> getUserName() async {
  try {
    final User user = FirebaseAuth.instance.currentUser!;

    final uid = user.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();

    if (userDoc.exists) {
      final userName = userDoc.data()?['name'];
      return userName as String;
    }
    return null;
  } catch (e) {
    throw Exception('No se pudo obtener el nombre del usuario.');
  }
}

void registerPropietario(
  BuildContext context,
  String propietario,
  String direccion,
  String telefono,
  String email,
  String password,
  String passwordConf,
) async {
  try {
    if (propietario.isEmpty ||
        direccion.isEmpty ||
        telefono.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        passwordConf.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, complete todos los campos',
          AlertMessageType.warning);
    } else {
      bool isEmailValid = AuthController.validateEmail(email);
      bool isPasswordValid =
          AuthController.validatePasswords(password, passwordConf);

      if (isEmailValid && isPasswordValid) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String idUser = userCredential.user!.uid;

        Usuario usuario = Usuario(
          id: idUser,
          name: propietario,
          address: direccion,
          email: email,
          phone: telefono,
        );

        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(idUser)
            .set(usuario.toJson());

        showPersonalizedAlert(
            context, "Registro exitoso", AlertMessageType.notification);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginController()),
        );
      }
    }
  } catch (e) {
    if (e is FirebaseAuthException) {
      showPersonalizedAlert(
          context,
          'Error al registrar al usuario: ${e.message}',
          AlertMessageType.error);
    } else {
      showPersonalizedAlert(
          context, 'Error al registrar al usuario: $e', AlertMessageType.error);
    }
  }
}

// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api, unused_element
//FUNCIONA BIEN
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notify_home/controllers/controller_auxiliar.dart';
import 'package:notify_home/controllers/login_controller.dart';
import 'package:notify_home/models/expert.dart';
import 'package:notify_home/controllers/alert_dialog.dart';

void registerExperto(String experto, String telefono, String email,
    String password, String passwordConf, BuildContext context) async {
  try {
    if (experto.isEmpty || telefono.isEmpty || email.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, complete todos los campos',
          AlertMessageType.warning);
    } else {
      bool isEmailValid = AuthController.validateEmail(email);
      bool isPasswordValid =
          AuthController.validatePasswords(password, passwordConf);
      if (isEmailValid && isPasswordValid) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String idUser = FirebaseAuth.instance.currentUser!.uid;

        Experto expert = Experto(
          id: idUser,
          name: experto,
          email: email,
          phone: telefono,
        );

        await FirebaseFirestore.instance
            .collection('experto')
            .doc(idUser)
            .set(expert.toJson());

        showPersonalizedAlert(
          context,
          "Registro exitoso",
          AlertMessageType.notification,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginController()),
        );
      }
    }
  } catch (e) {
    showPersonalizedAlert(
        context, 'Error al registrar el experto $e', AlertMessageType.error);
  }
}

Future<String?> getUserNameExperto() async {
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

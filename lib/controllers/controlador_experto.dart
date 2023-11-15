// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api, unused_element, avoid_print, unrelated_type_equality_checks
//FUNCIONA BIEN
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notify_home/controllers/controller_auxiliar.dart';
import 'package:notify_home/controllers/login_controller.dart';
import 'package:notify_home/models/experto.dart';
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

Future<List<Experto>> getExpertoDetails() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Realiza la consulta a Firebase Firestore
    QuerySnapshot snapshot = await firestore.collection('experto').get();

    // Inicializa una lista para almacenar los electrodomésticos
    List<Experto> expertos = [];
    // Recorre los documentos y crea instancias de la clase Appliance
    for (var doc in snapshot.docs) {
      expertos.add(Experto(
        id: doc.id,
        name: doc['name'],
        email: doc['email'],
        phone: doc['phone'],
      ));
    }
    // Devuelve la lista de electrodomésticos
    return expertos;
  } catch (e) {
    // Maneja errores de forma adecuada
    print('Error, no se logro obtener la información de los expertos: $e');
    throw Exception('No se pudo obtener la información de los expertos.');
  }
}

List<Experto> filterExpertos(List<Experto> expertos, String searchTerm) {
  // Filtra la lista de expertos basados en el término de búsqueda.
  return expertos.where((expert) {
    return expert.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
        expert.email.toLowerCase().contains(searchTerm.toLowerCase()) ||
        expert.phone.contains(searchTerm);
  }).toList();
}

Future<String> getExpertoName(String idExperto) async {
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

//import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:notify_home/models/user.dart';
import 'package:flutter/material.dart';

class AuthController {
  static bool validateEmail(String email) {
    // Expresión regular para verificar el formato del correo electrónico
    String emailPattern =
        r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  static bool validatePasswords(String password, String passwordConf) {
    // La contraseña debe contener al menos 6 caracteres, incluyendo al menos una letra mayúscula, una minúscula y un número.
    String passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$';
    RegExp regex = RegExp(passwordPattern);

    if (password != passwordConf) {
      return false;
    }
    return regex.hasMatch(password);
  }
}

/*class UserController {
  Future<Usuario> getUsuarioDetails(String usuarioId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioId)
        .get();
    if (snapshot.exists) {
      return Usuario(
        id: snapshot.id,
        name: snapshot['name'],
        email: snapshot['email'],
        phone: snapshot['phone'],
      );
    } else {
      throw Exception('No se encontró la empresa en la base de datos');
    }
  }
}*/

void clearTextField(TextEditingController controller) {
  controller.clear();
}

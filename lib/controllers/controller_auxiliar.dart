import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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

void clearTextField(TextEditingController controller) {
  controller.clear();
}

String generateApplianceId() {
    var uuid = const Uuid();
    return uuid.v4();
  }

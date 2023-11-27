// ignore_for_file: avoid_print

import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AuthController {
  // Función estática para validar el formato de un correo electrónico
  static bool validateEmail(String email) {
    // Expresión regular para verificar el formato del correo electrónico
    String emailPattern =
        r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  // Función estática para validar contraseñas y verificar si coinciden
  static bool validatePasswords(String password, String passwordConf) {
    // La contraseña debe contener al menos 10 caracteres, incluyendo al menos una letra mayúscula, una minúscula y un número.
    String passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{10,}$';
    RegExp regex = RegExp(passwordPattern);

    // Verificar si las contraseñas coinciden y cumplen con los requisitos
    if (password != passwordConf) {
      return false;
    }
    return regex.hasMatch(password);
  }
}

// Función para limpiar el contenido de un controlador de texto
void clearTextField(TextEditingController controller) {
  controller.clear();
}

// Función para generar un identificador único
String generateId() {
  var uuid = const Uuid();
  return uuid.v4();
}

// Función para obtener el año actual
int anho() {
  return DateTime.now().year;
}

// Función para obtener el mes actual
int mes() {
  return DateTime.now().month;
}

// Función para obtener el día actual
int dia() {
  return DateTime.now().day;
}

// Función para verificar si una contraseña cumple con los requisitos
bool checkPasswordRequirements(String password) {
  // La contraseña debe contener al menos 10 caracteres, incluyendo al menos una letra mayúscula, una minúscula y un número.
  String passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{10,}$';
  RegExp regex = RegExp(passwordPattern);
  return regex.hasMatch(password);
}

// Función para obtener el ID único del dispositivo
Future<String> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try {
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    } else {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.androidId;
    }
  } catch (e) {
    print('Error obtaining device ID: $e');
    return "";
  }
}

// Función para verificar si un número de teléfono tiene la longitud correcta, en este caso longitud 10
bool isPhoneNumberValid(String phoneNumber) {
  return phoneNumber.length == 10;
}

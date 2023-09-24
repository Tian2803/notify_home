// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notify_home/controllers/controller_login.dart';
import 'package:notify_home/models/expert.dart';
import 'package:notify_home/views/register_expert_view.dart';
import 'package:notify_home/controllers/controller_auxiliar.dart';
import 'package:notify_home/controllers/alert_dialog.dart';

class RegisterExpertController extends StatefulWidget {
  @override
  _RegisterExpertControllerState createState() => _RegisterExpertControllerState();
}

class _RegisterExpertControllerState extends State<RegisterExpertController> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfController = TextEditingController();

  final bool _isEmailValid = true;
  final bool _isPasswordValid = true;
  final bool _isPasswordConfValid = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfController.dispose();
    super.dispose();
  }

  void _register() async {
    try {
      String experto = _nombreController.text;
      String telefono = _telefonoController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String passwordConf = _passwordConfController.text;
      if (experto.isEmpty ||
          telefono.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          passwordConf.isEmpty) {
            showPersonalizedAlert(context, 'Por favor, complete todos los campos', AlertMessageType.warning);
      } else {
        // Validar los campos y realizar el registro si son válidos
        bool isEmailValid = AuthController.validateEmail(email);
        bool isPasswordValid = AuthController.validatePasswords(password, passwordConf);

        if (isEmailValid && isPasswordValid) {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          Experto expert = Experto(
            id: userCredential.user!.uid,
            name: experto,
            email: email,
            phone: telefono,
          );

          clearTextField(_nombreController);
          clearTextField(_telefonoController);
          clearTextField(_emailController);
          clearTextField(_passwordController);
          clearTextField(_passwordConfController);      

          String userId = userCredential.user!.uid;
          await FirebaseFirestore.instance
              .collection('expertos')
              .doc(userId)
              .set(expert.toJson())
              .then((value) => {
                    showPersonalizedAlert(context, "Registro exitoso", AlertMessageType.notification),
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginController()))
                  });
        }
      }
    } catch (e) {
      showPersonalizedAlert(context,'Error al registrar el experto $e',AlertMessageType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RegisterExpertView(
      nombreController: _nombreController,
      telefonoController: _telefonoController,
      emailController: _emailController,
      passwordController: _passwordController,
      passwordConfController: _passwordConfController,
      isEmailValid: _isEmailValid,
      isPasswordValid: _isPasswordValid,
      isPasswordConfValid: _isPasswordConfValid,
      registerPressed: _register,
    );
  }
}
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:notify_home/controllers/controlador_experto.dart';
import 'package:notify_home/views/control_acceso_autenticacion/login_view.dart';
import 'package:notify_home/views/vista_principal_experto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notify_home/views/vista_principal_propietario.dart';
import 'package:notify_home/controllers/alert_dialog.dart';

class LoginController extends StatefulWidget {
  const LoginController({super.key});

  @override
  _LoginControllerState createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final bool _isEmailValid = true;
  final bool _isPasswordValid = true;

  void signInWithEmailAndPassword(String email, String password) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      // Extrayendo la información de la compañía autenticada desde la base de datos
      User? user = userCredential.user;
      String userId = user!.uid;

      //se usa el operador await para esperar a que getExpertoId() se complete.
      String? expId = await getExpertoId();
      // Navegando a la vista de electrodomesticos
      if (userId == expId) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeViewExpert()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeViewUser()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showPersonalizedAlert(
            context, 'Usuario no encontrado', AlertMessageType.warning);
      } else if (e.code == 'wrong-password') {
        showPersonalizedAlert(
            context, 'Contraseña incorrecta', AlertMessageType.warning);
      }
    }
  }

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validando que el email y la contraseña no estén vacíos
    if (email.isEmpty || password.isEmpty) {
      showPersonalizedAlert(context, 'Por favor ingrese su email y contraseña',
          AlertMessageType.error);
      return;
    }

    signInWithEmailAndPassword(email, password);
  }

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

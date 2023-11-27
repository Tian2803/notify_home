// Vista de la pantalla de inicio de sesión
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:notify_home/views/control_acceso_autenticacion/vista_escoger_tipo_usuaerio.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isEmailValid;
  final bool isPasswordValid;
  final VoidCallback loginPressed;

  LoginView({
    required this.emailController,
    required this.passwordController,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.loginPressed,
  });

  // Widget para la imagen de presentación
  final photo = Container(
    margin: const EdgeInsets.only(
      top: 40.0,
    ),
    width: 230.0,
    height: 280.0,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage("assets/images/logo.jpg"))),
  );

  // Widget para el mensaje de bienvenida
  final comment = const Text(
    "Hola, Bienvenido a Notify Hogar",
    textAlign: TextAlign.justify,
    style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
  );

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen de presentación
            photo,
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),

            // Mensaje de bienvenida
            comment,
            SizedBox(height: MediaQuery.of(context).size.height * 0.035),

            // Campo de correo electrónico
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  labelText: 'Correo electrónico',
                  border: const OutlineInputBorder(),
                  errorText:
                      isEmailValid ? null : 'Correo electrónico inválido',
                ),
              ),
            ),

            // Espaciado después del campo de correo electrónico
            SizedBox(height: 30, width: widthDevice),

            // Campo de contraseña
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    labelText: 'Contraseña',
                    errorText: isPasswordValid ? null : 'Contraseña inválida',
                    border: const OutlineInputBorder()),
                obscureText: true,
              ),
            ),

            // Espaciado después del campo de contraseña
            SizedBox(height: MediaQuery.of(context).size.height * 0.050),

            // Botón de inicio de sesión
            ElevatedButton(
              onPressed: loginPressed,
              child: const Text('Iniciar sesión'),
            ),

            // Espaciado después del botón de inicio de sesión
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            // Enlace para crear una cuenta
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Alineación de los botones y espacio entre ellos
              children: <Widget>[
                const Text("¿No tienes cuenta? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseRegister()));
                  },
                  child: const Text(
                    "Crear",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

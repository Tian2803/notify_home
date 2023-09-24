import 'package:flutter/material.dart';

class RegisterExpertView extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController telefonoController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfController;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordConfValid;
  final VoidCallback registerPressed;

  RegisterExpertView(
      {super.key,
      required this.registerPressed,
      required this.isEmailValid,
      required this.isPasswordValid,
      required this.isPasswordConfValid,
      required this.nombreController,
      required this.telefonoController,
      required this.emailController,
      required this.passwordController,
      required this.passwordConfController});

  final photo = Container(
    width: 200.0,
    height: 260.0,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage("assets/images/logo.jpg"))),
  );

  final comment = Container(
  width: double.infinity, // Ancho máximo
  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Espaciado horizontal
  child: const Align(
    alignment: Alignment.centerLeft, // Alineación izquierda
    child: Text(
      "Hola, Bienvenido al registro de Notify Hogar.",
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
    ),
  ),
);


  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(
        title: const Text('Registro de experto'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            photo,
            SizedBox(height: MediaQuery.of(context).size.height * 0.020),
            comment,
            SizedBox(height: MediaQuery.of(context).size.height * 0.030),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: telefonoController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    labelText: 'Telefono',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
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
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    labelText: 'Contraseña',
                    //errorText: isPasswordValid ? null : 'Contraseña inválida',
                    border: OutlineInputBorder()),
                obscureText: true,
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: passwordConfController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    labelText: 'Confirmar contraseña',
                    //errorText:
                    //isPasswordConfValid ? null : 'Contraseña inválida',
                    border: OutlineInputBorder()),
                obscureText: true,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.040),
            ElevatedButton(
              onPressed: registerPressed,
              child: const Text('Registrarse'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.040),
          ],
        ),
      ),
    );
  }
}

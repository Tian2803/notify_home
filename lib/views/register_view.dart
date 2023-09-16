import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController direccionController;
  final TextEditingController telefonoController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfController;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordConfValid;
  final VoidCallback registerPressed;

  RegisterView(
      {super.key, required this.registerPressed,
      required this.isEmailValid,
      required this.isPasswordValid,
      required this.isPasswordConfValid,
      required this.nombreController,
      required this.direccionController,
      required this.telefonoController,
      required this.emailController,
      required this.passwordController,
      required this.passwordConfController});

  final photo = Container(
      margin: const EdgeInsets.only(
        top: 20.0,
      ),

      width: 220.0,
      height: 280.0,

      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/logo.jpg"))
      ),
    );

    final comment = const Text(
      "Hola, Bienvenido al registro de Notify Hogar",
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 19.0,
        fontWeight: FontWeight.bold
      ),
    );

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro usuario'),
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            photo,
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            comment,
            SizedBox(height: MediaQuery.of(context).size.height * 0.035),
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
                controller: direccionController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.home_work),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    labelText: 'Direccion',
                    border: OutlineInputBorder()),
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
            ),SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          ],
        ),
      ),
    );
  }
}
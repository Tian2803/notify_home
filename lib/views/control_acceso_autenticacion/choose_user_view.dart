//FUNCIONA BIEN
import 'package:flutter/material.dart';
import 'package:notify_home/views/control_acceso_autenticacion/vista_registro_experto.dart';
import 'package:notify_home/views/control_acceso_autenticacion/vista_registro_propietario.dart';

class ChooseRegister extends StatelessWidget {
  const ChooseRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(
        title: const Text("Tipo de usuario"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Sección "Propietario Electrodomestico"
            Container(
              width: 340,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Propietario Electrodomestico',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "Si eres un usuario regular que desea utilizar nuestra plataforma para acceder a servicio de gestion de mantenimiento de electrodomesticos, elige esta opción.",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterUserView(),
                        ),
                      );
                    },
                    child: const Text('Presiona aqui'),
                  ),
                ],
              ),
            ),

            // Sección "Experto en Mantenimiento de Electrodomésticos"
            Container(
              width: 340,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Experto en Mantenimiento de Electrodomésticos',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "Si eres un profesional con experiencia en la reparación y mantenimiento de electrodomésticos y deseas ofrecer tus servicios a otros usuarios, elige esta opción.",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterExpertView(),
                        ),
                      );
                    },
                    child: const Text('Presiona aqui'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

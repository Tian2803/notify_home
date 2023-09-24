import 'package:flutter/material.dart';
import 'package:notify_home/controllers/controller_register_expert.dart';
import 'package:notify_home/controllers/controller_register_user.dart';

class ChooseRegister extends StatelessWidget {
  ChooseRegister({super.key});

  final photo = Container(
    width: 160.0,
    height: 180.0,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage("assets/images/logo.jpg"))),
  );

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
            //photo,
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
                  const Text('Usuario Normal',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center),
                  const Text(
                    "Si eres un usuario regular que desea utilizar nuestra plataforma para acceder a servicio de gestion de mantenimiento de electrodomesticos, elige esta opción.",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                        textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterUserController()));
                    },
                    child: const Text('Presiona aqui'),
                  ),
                ],
              ),
            ),
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
                  const Text('Experto en Mantenimiento de Electrodomésticos',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center),
                  const Text(
                    "Si eres un profesional con experiencia en la reparación y mantenimiento de electrodomésticos y deseas ofrecer tus servicios a otros usuarios, elige esta opción.",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                        textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterExpertController()));
                    },
                    child:
                        const Text('Presiona aqui'),
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

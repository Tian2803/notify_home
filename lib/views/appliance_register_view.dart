// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ApplianceRegisterView extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController placeController;
  final TextEditingController descriptionController;
  final TextEditingController useController;
  final TextEditingController frequencyController;
  final VoidCallback registerPressed;

  const ApplianceRegisterView({
    required this.nameController,
    required this.placeController,
    required this.descriptionController,
    required this.useController,
    required this.frequencyController,
    required this.registerPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(
        title: const Text('Registrar electrodomestico'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(children: [
            Expanded(
              child: ListView(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del electrodomestico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.tv),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del electrodomestico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: placeController,
                  decoration: const InputDecoration(
                    labelText: 'Ubicacion',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.navigation_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la ubicacion de electrodomestico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la descripción del electrodomestico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: useController,
                  decoration: const InputDecoration(
                    labelText: 'Tiempo de uso  en horas',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.timelapse_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el tiempo de uso  en horas';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: frequencyController,
                  decoration: const InputDecoration(
                    labelText: 'Frecuencia de uso',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.timer),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la frecuencia de uso';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
              ]),
            ),
            ElevatedButton(
              onPressed: registerPressed,
              child: const Text('Registrar'),
            ),
          ]),
        ),
      ),
    );
  }
}
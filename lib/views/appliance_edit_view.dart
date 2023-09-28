// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ApplianceEditView extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController fabricanteController;
  final TextEditingController modeloController;
  final TextEditingController tipoController;
  final TextEditingController condicionAmbController;
  final TextEditingController fechaCompraController;
  final TextEditingController fechaInstalacionController;
  final TextEditingController fechaManteManualController;
  final TextEditingController fechaUltMantController;
  final TextEditingController tiempoUsoController;
  final TextEditingController frecuenciaUsoController;
  final TextEditingController ubicacionController;
  final VoidCallback updatePressed;

  const ApplianceEditView({
    required this.nameController,
    required this.fabricanteController,
    required this.modeloController,
    required this.tipoController,
    required this.condicionAmbController,
    required this.fechaCompraController,
    required this.fechaInstalacionController,
    required this.fechaManteManualController,
    required this.fechaUltMantController,
    required this.tiempoUsoController,
    required this.frecuenciaUsoController,
    required this.ubicacionController,
    required this.updatePressed,
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
                  controller: fabricanteController,
                  decoration: const InputDecoration(
                    labelText: 'Fabricante',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese nombre fabricante';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: modeloController,
                  decoration: const InputDecoration(
                    labelText: 'Modelo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.unfold_more_double_sharp),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el modelo del electrodomestico';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: tipoController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.energy_savings_leaf),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el tipo de electrodomestico';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: condicionAmbController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.air_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la condicion ambiental';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: fechaCompraController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha compra',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha de compra del electrodomestico';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: fechaInstalacionController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha instalacion',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha de instalacion del electrodomestico';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: fechaManteManualController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha mantenimiento del manual de usuario',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha de instalacion del electrodomestico';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: fechaUltMantController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha ultimo mantenimiento',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha del del ultimo mantenimineto del electrodomestico';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: tiempoUsoController,
                  decoration: const InputDecoration(
                    labelText: 'Tiempo de uso',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.timer_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el tiempo de uso del electrodomestico';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: frecuenciaUsoController,
                  decoration: const InputDecoration(
                    labelText: 'Frecuencia de uso',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.av_timer_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la frecuencia de uso del electrodomestico';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                TextFormField(
                  controller: ubicacionController,
                  decoration: const InputDecoration(
                    labelText: 'Ubicacion',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.navigation_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la ubicacion del electrodomestico';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
              ]),
            ),
            ElevatedButton(
              onPressed: updatePressed,
              child: const Text('Guardar cambios'),
            ),
          ]),
        ),
      ),
    );
  }
}
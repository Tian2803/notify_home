// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notify_home/controllers/alert_dialog.dart';

class ApplianceEditView extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController fabricanteController;
  final TextEditingController modeloController;
  final TextEditingController calificacionEnergeticaController;
  final VoidCallback updatePressed;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ApplianceEditView({
    required this.nameController,
    required this.fabricanteController,
    required this.modeloController,
    required this.calificacionEnergeticaController,
    required this.updatePressed,
  });

  @override
  Widget build(BuildContext context) {
    // Scaffold para la vista de edición de electrodomésticos
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(
        title: const Text('Editar electrodomestico'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            // Lista expandida para contener los elementos del formulario
            Expanded(
              child: ListView(children: [
                const SizedBox(height: 5),
                // Campo de texto para el nombre del electrodoméstico
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del electrodomestico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.tv),
                  ),
                  // Validación del campo
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del electrodomestico';
                    }
                    return null;
                  },
                  // Filtro para permitir solo caracteres alfabéticos
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Campo de texto para el fabricante del electrodoméstico
                TextFormField(
                  controller: fabricanteController,
                  decoration: const InputDecoration(
                    labelText: 'Fabricante',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  // Validación del campo
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese nombre fabricante';
                    }
                    return null;
                  },
                  // Filtro para permitir solo caracteres alfabéticos
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Campo de texto para el modelo del electrodoméstico
                TextFormField(
                  controller: modeloController,
                  decoration: const InputDecoration(
                    labelText: 'Modelo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.unfold_more_double_sharp),
                  ),
                  // Validación del campo
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el modelo del electrodomestico';
                    }
                    return null;
                  },
                  // Filtro para permitir caracteres alfanuméricos
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  readOnly: false, // Permite edición del campo
                ),
                const SizedBox(height: 16.0),
                // Campo de texto para la calificación energética del electrodoméstico
                TextFormField(
                  controller: calificacionEnergeticaController,
                  decoration: const InputDecoration(
                    labelText: 'Calificacion energetica',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.energy_savings_leaf),
                  ),
                  // Validación del campo
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la calificacion energetica';
                    }
                    return null;
                  },
                  // Filtro para permitir solo letras mayúsculas
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')),
                  ],
                  readOnly: false, // Permite edición del campo
                ),
              ]),
            ),
            // Botón elevado para guardar cambios en el electrodoméstico
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  updatePressed();
                } else {
                  showPersonalizedAlert(
                      context,
                      "Corrija los errores en el formulario",
                      AlertMessageType.error);
                }
              },
              child: const Text('Guardar cambios'),
            ),
          ]),
        ),
      ),
    );
  }
}

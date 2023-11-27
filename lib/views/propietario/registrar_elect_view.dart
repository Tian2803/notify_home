// ignore_for_file: modelo_key_in_widget_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/electrodomestico_controller.dart';
import 'package:notify_home/controllers/auxiliar_controller.dart';
import 'package:notify_home/controllers/evento_controller.dart';
import 'package:notify_home/controllers/hoja_vida_controller.dart';

class ApplianceRegisterView extends StatefulWidget {
  const ApplianceRegisterView({super.key});

  @override
  State<ApplianceRegisterView> createState() => _ApplianceRegisterViewState();
}

class _ApplianceRegisterViewState extends State<ApplianceRegisterView> {
  // Controladores para los campos de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fabricanteController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController calificacionEnergeticaController =
      TextEditingController();
  final TextEditingController condicionAmbController = TextEditingController();
  final TextEditingController fechaCompraController = TextEditingController();
  final TextEditingController fechaInstalacionController =
      TextEditingController();
  final TextEditingController fechaUltMantController = TextEditingController();
  final TextEditingController tiempoUsoController = TextEditingController();
  final TextEditingController frecuenciaUsoController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Lista de opciones para la frecuencia de uso
  List<String> items = ["Diario", "3 dias a la semana", "5 dias a la semana"];
  String? selectedValue;

  // Genera un ID único para el electrodoméstico
  String applianceId = generateId();

  @override
  Widget build(BuildContext context) {
    // Estructura del widget para el registro de electrodomésticos
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(
        title: const Text('Registrar electrodomestico'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[ a-zA-Z0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del electrodomestico';
                    }
                    return null;
                  },
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese nombre fabricante';
                    }
                    return null;
                  },
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el modelo del electrodomestico';
                    }
                    return null;
                  },
                  readOnly: false,
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la calificacion energetica de electrodomestico';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                const SizedBox(height: 16.0),
                // Campo de texto para la condición ambiental del electrodoméstico
                TextFormField(
                  controller: condicionAmbController,
                  decoration: const InputDecoration(
                    labelText: 'Condicion ambiental',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.air_outlined),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la condicion ambiental';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                const SizedBox(height: 16.0),
                // Campo de texto para la fecha de compra del electrodoméstico
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
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now());

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      fechaCompraController.text = formattedDate;
                    } else {}
                  },
                ),
                const SizedBox(height: 16.0),
                // Campo de texto para la fecha de instalación del electrodoméstico
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
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now());

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      fechaInstalacionController.text = formattedDate;
                    } else {}
                  },
                ),
                const SizedBox(height: 16.0),
                // Campo de texto para la fecha del último mantenimiento del electrodoméstico
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
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now());

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      fechaUltMantController.text = formattedDate;
                    } else {}
                  },
                ),
                const SizedBox(height: 16.0),
                // Campo de texto para el tiempo de uso del electrodoméstico
                TextFormField(
                  controller: tiempoUsoController,
                  decoration: const InputDecoration(
                    labelText: 'Tiempo de uso',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.timer_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el tiempo de uso del electrodomestico';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                const SizedBox(height: 16.0),
                // Menú desplegable para seleccionar la frecuencia de uso del electrodoméstico
                DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Text(
                    'Seleccione la frecuencia de uso',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  items: items
                      .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 16),
                          )))
                      .toList(),
                  value: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: 140,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                )),
                const SizedBox(height: 16.0),
                // Campo de texto para la ubicación del electrodoméstico
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
            const SizedBox(height: 25.0),
            // Botón para registrar el electrodoméstico
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Calcular antigüedad, prioridad y realizar los registros en la base de datos
                  int antiguedad = calcularAntiguedadEnAnios(
                      fechaCompraController.text,
                      fechaInstalacionController.text);
                  String prioridad = calcularPrioridadMantenimiento(
                      antiguedad,
                      fechaUltMantController.text,
                      frecuenciaUsoController.text,
                      int.parse(tiempoUsoController.text));

                  registrarElectrodomestico(
                      context,
                      nameController.text,
                      fabricanteController.text,
                      modeloController.text,
                      calificacionEnergeticaController.text,
                      applianceId);
                  registrarHojaVida(
                      context,
                      condicionAmbController.text,
                      fechaCompraController.text,
                      fechaInstalacionController.text,
                      fechaUltMantController.text,
                      tiempoUsoController.text,
                      selectedValue as String,
                      ubicacionController.text,
                      applianceId);
                  //Asigna la fecha de mantenimiento del electrodomestico
                  asignarFechaMantenimiento(
                      context,
                      prioridad,
                      DateTime.parse(fechaUltMantController.text),
                      "Fecha mantenimiento ${nameController.text}",
                      nameController.text);
                } else {
                  // Mostrar alerta en caso de errores en el formulario
                  showPersonalizedAlert(
                      context,
                      "Corrija los errores en el formulario",
                      AlertMessageType.error);
                }
              },
              child: const Text('Registrar'),
            ),
          ]),
        ),
      ),
    );
  }
}

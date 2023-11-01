// ignore_for_file: modelo_key_in_widget_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify_home/controllers/controller_appliance.dart';
import 'package:notify_home/controllers/controller_auxiliar.dart';
import 'package:notify_home/controllers/hoja_vida_electrodomestico_controller.dart';

class ApplianceRegisterView extends StatefulWidget {
  const ApplianceRegisterView({super.key});

  @override
  State<ApplianceRegisterView> createState() => _ApplianceRegisterViewState();
}

class _ApplianceRegisterViewState extends State<ApplianceRegisterView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fabricanteController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController condicionAmbController = TextEditingController();
  final TextEditingController fechaCompraController = TextEditingController();
  final TextEditingController fechaInstalacionController =
      TextEditingController();
  final TextEditingController fechaManteManualController =
      TextEditingController();
  final TextEditingController fechaUltMantController = TextEditingController();
  final TextEditingController tiempoUsoController = TextEditingController();
  final TextEditingController frecuenciaUsoController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();

  List<String> items = ["Diario", "Semanal", "Mensual"];
  String? selectedValue;

  String applianceId = generateApplianceId();
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
                const SizedBox(height: 5),
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
                    labelText: 'Condicion ambiental',
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
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha de compra del electrodomestico';
                    }
                    return null;
                  },*/
                  readOnly: false,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      fechaCompraController.text = formattedDate;
                    } else {}
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: fechaInstalacionController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha instalacion',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range_rounded),
                  ),
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha de instalacion del electrodomestico';
                    }
                    return null;
                  },*/
                  readOnly: false,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      fechaInstalacionController.text = formattedDate;
                    } else {}
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: fechaManteManualController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha mantenimiento del manual de usuario',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range_rounded),
                  ),
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha de instalacion del electrodomestico';
                    }
                    return null;
                  },*/
                  readOnly: false,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      fechaManteManualController.text = formattedDate;
                    } else {}
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: fechaUltMantController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha ultimo mantenimiento',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range_rounded),
                  ),
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha del del ultimo mantenimineto del electrodomestico';
                    }
                    return null;
                  },*/
                  readOnly: false,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      fechaUltMantController.text = formattedDate;
                    } else {}
                  },
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
                DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Text(
                    'Seleccione la frecuencia de uso',
                    style: TextStyle(
                        fontSize: 16, color: Colors.black),
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
            ElevatedButton(
              onPressed: () {
                registerAppliance(
                    context,
                    nameController.text,
                    fabricanteController.text,
                    modeloController.text,
                    tipoController.text,
                    applianceId);
                registerHojaVida(
                    context,
                    condicionAmbController.text,
                    fechaCompraController.text,
                    fechaInstalacionController.text,
                    fechaManteManualController.text,
                    fechaUltMantController.text,
                    tiempoUsoController.text,
                    selectedValue as String,
                    ubicacionController.text,
                    applianceId);
              },
              child: const Text('Registrar'),
            ),
          ]),
        ),
      ),
    );
  }
}

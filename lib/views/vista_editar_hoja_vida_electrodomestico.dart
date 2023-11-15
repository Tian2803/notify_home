// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';

class HVEditView extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController fabricanteController;
  final TextEditingController modeloController;
  final TextEditingController calificacionEnergeticaController;
  final TextEditingController condicionAmbController;
  final TextEditingController fechaCompraController;
  final TextEditingController fechaInstalacionController;
  final TextEditingController fechaUltMantController;
  final TextEditingController tiempoUsoController;
  final TextEditingController frecuenciaUsoController;
  final TextEditingController ubicacionController;
  final VoidCallback updatePressed;

  HVEditView({
    Key? key,
    required this.nameController,
    required this.fabricanteController,
    required this.modeloController,
    required this.calificacionEnergeticaController,
    required this.condicionAmbController,
    required this.fechaCompraController,
    required this.fechaInstalacionController,
    required this.fechaUltMantController,
    required this.tiempoUsoController,
    required this.frecuenciaUsoController,
    required this.ubicacionController,
    required this.updatePressed,
  }) : super(key: key);

  @override
  _HVEditViewState createState() => _HVEditViewState();
}

class _HVEditViewState extends State<HVEditView> {
  String? selectedValue;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.frecuenciaUsoController.text;
  }

  List<String> items = ["Diario", "Semanal", "Mensual"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(
        title: const Text('Editar hoja vida'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(children: [
            Expanded(
              child: ListView(children: [
                const SizedBox(height: 5),
                TextFormField(
                  controller: widget.nameController,
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
                  readOnly: true,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widget.fabricanteController,
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
                  readOnly: true,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widget.modeloController,
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
                  readOnly: true,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widget.calificacionEnergeticaController,
                  decoration: const InputDecoration(
                    labelText: 'Calificacion energetica',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.energy_savings_leaf),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la  calificacion energetica de electrodomestico';
                    }
                    return null;
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widget.condicionAmbController,
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
                  controller: widget.fechaCompraController,
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
                      widget.fechaCompraController.text = formattedDate;
                    } else {}
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widget.fechaInstalacionController,
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
                      widget.fechaInstalacionController.text = formattedDate;
                    } else {}
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widget.fechaUltMantController,
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
                      widget.fechaUltMantController.text = formattedDate;
                    } else {}
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widget.tiempoUsoController,
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
                      widget.frecuenciaUsoController.text = selectedValue as String;
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
                  controller: widget.ubicacionController,
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
              onPressed: widget.updatePressed,
              child: const Text('Guardar cambios'),
            ),
          ]),
        ),
      ),
    );
  }
}

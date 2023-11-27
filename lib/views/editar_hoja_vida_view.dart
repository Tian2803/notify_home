// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:notify_home/controllers/alert_dialog.dart';

// HVEditView es un StatefulWidget para la pantalla de edición de detalles de un electrodoméstico.
class HVEditView extends StatefulWidget {
  // Controladores para los campos de texto y función de devolución de llamada para la acción de actualización.
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

// Constructor de HVEditView que requiere controladores y función de actualización.
  const HVEditView({
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

  // Crea el estado correspondiente al widget.
  @override
  _HVEditViewState createState() => _HVEditViewState();
}

// Estado del widget HVEditView.
class _HVEditViewState extends State<HVEditView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedValue;

  // Inicializa el estado estableciendo el valor predeterminado para el menú desplegable.
  @override
  void initState() {
    super.initState();
    selectedValue = widget.frecuenciaUsoController.text;
  }

  // Lista de opciones para el menú desplegable.
  List<String> items = ["Diario", "5 dias a la semana", "3 dias a la semana"];

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
          key: _formKey,
          child: Column(
            children: [
              // Lista expandida que contiene varios TextFormField y DropdownButton.
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 5),
                    // Campo de formulario de texto para el nombre del electrodoméstico.
                    TextFormField(
                      controller: widget.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del electrodomestico',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.tv),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre del electrodomestico';
                        }
                        return null;
                      },
                      readOnly: true,
                    ),
                    const SizedBox(height: 16.0),
                    // Campo de formulario de texto para el fabricante del electrodoméstico.
                    TextFormField(
                      controller: widget.fabricanteController,
                      decoration: const InputDecoration(
                        labelText: 'Fabricante',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre del fabricante';
                        }
                        return null;
                      },
                      readOnly: true,
                    ),
                    const SizedBox(height: 16.0),
                    // Campo de formulario de texto para el modelo del electrodoméstico.
                    TextFormField(
                      controller: widget.modeloController,
                      decoration: const InputDecoration(
                        labelText: 'Modelo',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.unfold_more_double_sharp),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el modelo del electrodomestico';
                        }
                        return null;
                      },
                      readOnly: true,
                    ),
                    const SizedBox(height: 16.0),
                    // Campo de formulario de texto para la calificación energética del electrodoméstico.
                    TextFormField(
                      controller: widget.calificacionEnergeticaController,
                      decoration: const InputDecoration(
                        labelText: 'Calificacion energetica',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.energy_savings_leaf),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la calificacion energetica del electrodomestico';
                        }
                        return null;
                      },
                      readOnly: true,
                    ),
                    const SizedBox(height: 16.0),

                    // Campo de formulario de texto para la condición ambiental del electrodoméstico.
                    TextFormField(
                      controller: widget.condicionAmbController,
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
                    // Campo de formulario de texto para la fecha de compra del electrodoméstico.
                    TextFormField(
                      controller: widget.fechaCompraController,
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
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          widget.fechaCompraController.text = formattedDate;
                        } else {}
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Campo de formulario de texto para la fecha de instalación del electrodoméstico.
                    TextFormField(
                      controller: widget.fechaInstalacionController,
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
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          widget.fechaInstalacionController.text =
                              formattedDate;
                        } else {}
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Campo de formulario de texto para la fecha del último mantenimiento del electrodoméstico.
                    TextFormField(
                      controller: widget.fechaUltMantController,
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
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          widget.fechaUltMantController.text = formattedDate;
                        } else {}
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Campo de formulario de texto para el tiempo de uso en horas del electrodoméstico.
                    TextFormField(
                      controller: widget.tiempoUsoController,
                      decoration: const InputDecoration(
                        labelText: 'Tiempo de uso en horas',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.timer_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.singleLineFormatter,
                        LengthLimitingTextInputFormatter(3),
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
                    // DropdownButton para la frecuencia de uso.
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
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value;
                            widget.frecuenciaUsoController.text =
                                selectedValue as String;
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
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Campo de formulario de texto para la ubicación del electrodoméstico.
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
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Botón elevado para guardar cambios con validación.
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.updatePressed();
                  } else {
                    showPersonalizedAlert(
                        context,
                        "Corrija los errores en el formulario",
                        AlertMessageType.error);
                  }
                },
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: modelo_key_in_widget_constructors, use_build_context_synchronously, avoid_print

// Importaciones necesarias para el funcionamiento del widget.
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:notify_home/controllers/electrodomestico_controller.dart';
import 'package:notify_home/controllers/evento_controller.dart';
import 'package:notify_home/controllers/hoja_vida_controller.dart';
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';

// Widget para la vista de predicción de mantenimiento.
class VistaPrediccion extends StatefulWidget {
  const VistaPrediccion({super.key});

  @override
  State<VistaPrediccion> createState() => _VistaPrediccionState();
}

class _VistaPrediccionState extends State<VistaPrediccion> {
  // Controladores para los campos de texto.
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController tiempoUsoController = TextEditingController();

  // ID del usuario actual.
  final uid = FirebaseAuth.instance.currentUser!.uid;

  // Lista de opciones para la frecuencia de uso.
  List<String> items = ["Diario", "3 dias a la semana", "5 dias a la semana"];

  // Lista de electrodomésticos disponibles.
  late List<String> electrodomesticos;

  // Valores seleccionados.
  String? selectedValue;
  String? selectedElectrodomestico;

  @override
  void initState() {
    super.initState();
    electrodomesticos = [];
    _loadAppliances();
  }

  // Método para cargar los electrodomésticos disponibles.
  Future<void> _loadAppliances() async {
    try {
      List<String> appliances =
          (await getElectrodomesticoNombre(uid)).cast<String>();
      setState(() {
        electrodomesticos = appliances;
      });
    } catch (e) {
      print('Error al obtener electrodomésticos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(
        title: const Text('Programar mantenimiento'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(children: [
            Expanded(
              child: ListView(children: [
                const SizedBox(height: 5),
                // Campo de texto para el título del evento.
                TextFormField(
                  controller: tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Titulo del evento',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(
                        '[ a-zA0-9Z]')), // Permitir solo caracteres alfabéticos
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el título del evento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Campo de texto para el tiempo de uso.
                TextFormField(
                  controller: tiempoUsoController,
                  decoration: const InputDecoration(
                    labelText: 'Tiempo de uso',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.timer_outlined),
                  ),
                  keyboardType: TextInputType.phone,
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
                // Menú desplegable para la frecuencia de uso.
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
                // Menú desplegable para seleccionar un electrodoméstico.
                if (electrodomesticos.isNotEmpty)
                  DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: const Text(
                      'Seleccione electrodomestico',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    items: electrodomesticos
                        .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 16),
                            )))
                        .toList(),
                    value: selectedElectrodomestico,
                    onChanged: (String? value) {
                      setState(() {
                        selectedElectrodomestico = value;
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
                  ))
                else
                  const Text('No hay electrodomésticos disponibles.'),
                const SizedBox(height: 16),
              ]),
            ),
            const SizedBox(height: 25.0),
            // Botón elevado para realizar la predicción de mantenimiento.
            ElevatedButton(
              onPressed: () async {
                // Obtener el ID del electrodoméstico seleccionado.
                final idElectrodomestico = await getElectrodomesticoId(
                    selectedElectrodomestico.toString(), uid);

                // Obtener la hoja de vida del electrodoméstico.
                HojaVidaElectrodomestico hojaVida =
                    await getHojaVidaElectrodomesticoDetalle(
                        uid, idElectrodomestico);

                // Formatear la fecha del último mantenimiento.
                String formattedDate = DateFormat('yyyy-MM-dd')
                    .format(hojaVida.fechaUltMantenimiento);

                // Calcular la antigüedad del electrodoméstico.
                int antiguedad = calcularAntiguedadEnAnios(
                    hojaVida.fechaCompra.toString(),
                    hojaVida.fechaInstalacion.toString());

                // Calcular la prioridad de mantenimiento.
                String prioridad = calcularPrioridadMantenimiento(
                    antiguedad,
                    formattedDate,
                    selectedValue.toString(),
                    int.parse(tiempoUsoController.text));

                // Asignar la fecha de mantenimiento.
                asignarFechaMantenimiento(
                    context,
                    prioridad,
                    DateTime.parse(formattedDate),
                    tituloController.text,
                    "Fecha mantenimiento $selectedElectrodomestico");

                // Limpiar los campos y valores seleccionados.
                setState(() {
                  tituloController.clear();
                  tiempoUsoController.clear();
                  selectedValue = null;
                  selectedElectrodomestico = null;
                });
              },
              child: const Text('Predecir'),
            ),
          ]),
        ),
      ),
    );
  }
}

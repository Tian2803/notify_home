// ignore_for_file: avoid_print

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/experto_controller.dart';
import 'package:notify_home/controllers/electrodomestico_controller.dart';
import 'package:notify_home/controllers/evento_controller.dart';
import 'package:notify_home/models/evento.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarNotify extends StatefulWidget {
  const CalendarNotify({super.key});

  @override
  State<CalendarNotify> createState() => _CalendarNotifyState();
}

class _CalendarNotifyState extends State<CalendarNotify> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  DateTime? _selectedDay;
  late CalendarFormat _calendarFormat;
  late DateTime currentDay;

  String? selectedElectrodomestico;
  String? selectedPrioridad;
  late List<String> items;
  late List<String> electrodomesticoAsignados;
  final List<String> prioridadOpciones = ['1', '2', '3'];

  late String? expertoId;

  late Map<DateTime, List<Evento>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  final TextEditingController nameEventoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es', null);
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    electrodomesticoAsignados = [];
    items = [];
    _loadAppliances();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    currentDay = DateTime.utc(2023, 11, 13);
    _loadFirestoreEvents();
  }

  Future<void> _loadAppliances() async {
    expertoId = await getExpertoId();
    try {
      if (uid != expertoId) {
        List<String> appliances =
            (await getElectrodomesticoNombre(uid)).cast<String>();
        setState(() {
          items = appliances;
        });
      } else {
        List<String> expertoElectrodomestico =
            (await getElectrodomesticoNombreExperto(uid));
        setState(() {
          electrodomesticoAsignados = expertoElectrodomestico;
        });
      }
    } catch (e) {
      print('Error al obtener electrodomésticos: $e');
    }
  }

  _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year + 5, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('evento')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
          fromFirestore: (snap, _) =>
              Evento.fromJson({...snap.data()!, 'id': snap.id}),
          toFirestore: (evento, _) => evento.toJson(),
        )
        .get();
    for (var doc in snap.docs) {
      if (doc.data().userId == uid) {
        final event = doc.data();
        final day = DateTime.utc(
          event.date.year,
          event.date.month,
          event.date.day,
        );
        if (_events[day] == null) {
          _events[day] = [];
        }
        _events[day]!.add(event);
        print(_events.length);
      }
    }
    setState(() {});
  }

  List<Evento> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(title: const Text('Calendario de mantenimiento')),
      floatingActionButton: addEventsToCalendar(context),
      body: ListView(
        children: [
          TableCalendar(
            // Configuración visual del calendario
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
            eventLoader: _getEventsForTheDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
                weekendTextStyle: TextStyle(
                  color: Colors.red,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                outsideDaysVisible: false),
          ),
          // Lista de eventos del día seleccionado
          ..._getEventsForTheDay(_selectedDay!).map((event) => ListTile(
                title: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors
                            .amber, // Puedes ajustar el color según tus preferencias
                      ),
                    ),
                    const SizedBox(
                        width: 8), // Espacio entre el círculo y el texto
                    Text(
                      "Titulo: ${event.titulo}",
                    ),
                  ],
                ),
                subtitle: Text(
                    "Fecha: ${DateFormat.yMMMMEEEEd('es').format(event.date)}"),
                onTap: () {},
                trailing: IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Eliminar evento?"),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Titulo: ${event.titulo}"),
                            Text("Fecha: ${event.date.toString()}"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context, true);
                              eliminarEvento(event);
                              _loadFirestoreEvents();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text("Si"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }

  // Botón flotante para agregar eventos al calendario
  FloatingActionButton addEventsToCalendar(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Evento'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         // Campo de texto para el nombre del evento
                        TextFormField(
                          controller: nameEventoController,
                          decoration: const InputDecoration(
                            hintText: 'Ingrese el nombre del evento',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese el nombre del evento';
                            }
                            return null;
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp('[ a-zA0-Z9]')),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // Menú desplegable para seleccionar la prioridad
                        DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Seleccione la prioridad',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          items: prioridadOpciones
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ))
                              .toList(),
                          value: selectedPrioridad,
                          onChanged: (String? value) {
                            setState(() {
                              selectedPrioridad = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 250,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (items.isNotEmpty && uid != expertoId)
                        // Menú desplegable para seleccionar electrodoméstico
                          DropdownButton2<String>(
                            isExpanded: true,
                            hint: const Text(
                              'Seleccione electrodomestico',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
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
                            value: selectedElectrodomestico,
                            onChanged: (String? value) {
                              setState(() {
                                selectedElectrodomestico = value;
                              });
                            },
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 40,
                              width: 250,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                          )
                        else
                          DropdownButton2<String>(
                            isExpanded: true,
                            hint: const Text(
                              'Seleccione electrodomestico',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            items: electrodomesticoAsignados
                                .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ))
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
                              width: 250,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                          ),
                        const SizedBox(height: 16),
                        // Campo de texto para la fecha
                        TextFormField(
                          controller: fechaController,
                          decoration: const InputDecoration(
                            labelText: 'Fecha',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.date_range_rounded),
                          ),
                          readOnly: false,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              // Formatear la fecha seleccionada
                              //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              fechaController.text = formattedDate;
                            } else {}
                          },
                        ),
                      ],
                    );
                  },
                ),
                actions: <Widget>[
                  // Botón para cerrar el cuadro de diálogo
                  TextButton(
                    onPressed: () {
                      selectedElectrodomestico = null;
                      selectedPrioridad = null;
                      nameEventoController.clear();
                      fechaController.clear();
                      Navigator.of(context).pop(); // Cerrar el AlertDialog
                    },
                    child: const Text('Cerrar'),
                  ),
                  // Botón para aceptar y registrar el evento
                  TextButton(
                    onPressed: () async {
                      if (nameEventoController.text.isEmpty ||
                          selectedPrioridad == null ||
                          fechaController.text.isEmpty ||
                          selectedElectrodomestico == null) {
                        // Muestra un mensaje de error si algún campo está vacío
                        showPersonalizedAlert(
                          context,
                          "Por favor, complete todos los campos.",
                          AlertMessageType.error,
                        );
                      } else {
                        // Registra el evento solo si todos los campos están llenos
                        registroEvento(
                          context,
                          nameEventoController.text,
                          int.parse(selectedPrioridad!),
                          selectedElectrodomestico!,
                          DateTime.parse(fechaController.text),
                        );

                        _loadFirestoreEvents();
                        nameEventoController.clear();
                        selectedPrioridad = null;
                        fechaController.clear();
                        selectedElectrodomestico = null;

                        // Cierra el cuadro de diálogo
                        Navigator.of(context).pop();
                        showPersonalizedAlert(
                          context,
                          "Evento registrado correctamente",
                          AlertMessageType.notification,
                        );
                      }
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              );
            });
      },
      child: const Icon(Icons.add),
    );
  }
}

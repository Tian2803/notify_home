// ignore_for_file: avoid_print

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/controller_electrodomestico.dart';
import 'package:notify_home/controllers/controller_evento.dart';
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

  String? selectedAppliance;
  late List<String> items;

  late Map<DateTime, List<Evento>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  final TextEditingController nameEventoController = TextEditingController();
  final TextEditingController prioridadController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es', null);
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );

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
    try {
      List<String> appliances =
          (await getApplianceWithInfo(uid)).cast<String>();
      setState(() {
        items = appliances;
      });
    } catch (e) {
      print('Error al obtener electrodomésticos: $e');
    }
  }

  _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
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
                              deleteEvento(event);
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

//Funciona bien
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
                        TextField(
                          controller: nameEventoController,
                          decoration: const InputDecoration(
                            hintText: 'Ingrese el nombre del evento',
                          ),
                        ),
                        TextField(
                          controller: prioridadController,
                          decoration: const InputDecoration(
                            hintText: 'Ingrese la prioridad del evento',
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (items.isNotEmpty)
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
                            value: selectedAppliance,
                            onChanged: (String? value) {
                              setState(() {
                                selectedAppliance = value;
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
                          const Text('No hay electrodomésticos disponibles.'),
                        const SizedBox(height: 16),
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
                  TextButton(
                    onPressed: () {
                      selectedAppliance = null;
                      Navigator.of(context).pop(); // Cerrar el AlertDialog
                    },
                    child: const Text('Cerrar'),
                  ),
                  if (items.isNotEmpty)
                    TextButton(
                      onPressed: () async {
                        if (selectedAppliance != null) {
                          registroEvento(
                            context,
                            nameEventoController.text,
                            int.parse(prioridadController.text),
                            selectedAppliance as String,
                            fechaController.text,
                          );

                          nameEventoController.clear;
                          prioridadController.clear;
                          selectedAppliance = null;
                          fechaController.clear;

                          _loadFirestoreEvents();
                          // Cierra el cuadro de diálogo
                          showPersonalizedAlert(
                              context,
                              "Evento registrado correctamente",
                              AlertMessageType.notification);
                          Navigator.of(context).pop();
                        } else {
                          print('Ningún electrodoméstico seleccionado.');
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

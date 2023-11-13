import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  Map<DateTime, List<Evento>> events = {};
  final TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Evento>> _selectedEvents;
  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _firstDay = DateTime.utc(2000, 1, 1);
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = _focusedDay;
    currentDay = DateTime.utc(2023, 11, 13);
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    _initialize();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  List<Evento> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  Future<void> _initialize() async {
    await cargarEventos();
  }

  //meter en un controlador
  void anadirEvento(String nombre) {
    final key = _selectedDay!; //DateTime.utc(año_db, mes_db, dia_db);
    final eventList = events[key] ?? [];
    eventList.add(Evento(titulo: nombre));
    events[key] = eventList;
  }

  // función para cargar eventos desde la base de datos
  Future<void> cargarEventos() async {
    try {
      print(uid);
      final eventos = await loadEventsForUser(uid);
      for (final evento in eventos) {
        final key = DateTime.utc(evento.anho, evento.mes, evento.dia);
        final eventList = events[key] ?? [];
        eventList.add(Evento(titulo: evento.titulo));
        setState(() {
          events[key] = eventList;
        });
      }
    } catch (e) {
      print("Error al cargar eventos: $e");
      // Manejar el error según sea necesario
      // Puedes lanzar una excepción o realizar otras acciones
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(title: const Text('Calendario de Mantenimientos')),
      floatingActionButton: addEventsToCalendar(context),
      body: Column(
        children: [
          TableCalendar<Evento>(
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
            onDaySelected: _onDaySelected,
            calendarStyle: const CalendarStyle(
                weekendTextStyle: TextStyle(
                  color: Colors.red,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.red,
                ),
                outsideDaysVisible: false),
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: ValueListenableBuilder<List<Evento>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            onTap: () => print(""),
                            title: Text('${value[index]}'),
                          ),
                        );
                      });
                }),
          )
        ],
      ),
    );
  }

  FloatingActionButton addEventsToCalendar(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Event'),
                content: TextField(
                  controller: _eventController,
                  decoration:
                      const InputDecoration(hintText: 'Enter your event name'),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          anadirEvento(_eventController.text);
                        });

                        Navigator.of(context).pop();
                        _selectedEvents.value = _getEventsForDay(_selectedDay!);
                      },
                      child: const Text('Ok'))
                ],
              );
            });
      },
      child: const Icon(Icons.add),
    );
  }
}

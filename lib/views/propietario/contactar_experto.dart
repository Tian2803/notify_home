// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/electrodomestico_controller.dart';
import 'package:notify_home/controllers/experto_controller.dart';
import 'package:notify_home/models/experto.dart';

class ContactarExperto extends StatefulWidget {
  const ContactarExperto({Key? key}) : super(key: key);

  @override
  State<ContactarExperto> createState() => _ContactarExpertoState();
}

class _ContactarExpertoState extends State<ContactarExperto> {
  // Icono y widget de búsqueda
  Icon iconSearch = const Icon(Icons.search);
  Widget cusSearch = const Text("Expertos");
  final TextEditingController _searchController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  // Variables para el manejo de electrodomésticos y expertos
  String? selectedAppliance;
  late List<String> items;
  late String expertId;

  @override
  void initState() {
    super.initState();
    items = [];
    _loadAppliances();
  }

  // Carga los electrodomésticos del usuario actual
  Future<void> _loadAppliances() async {
    try {
      List<String> appliances =
          (await getElectrodomesticoNombre(uid)).cast<String>();
      setState(() {
        items = appliances;
      });
    } catch (e) {
      print('Error al obtener electrodomésticos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Estructura del widget de la pantalla de contacto con expertos
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: cusSearch,
        actions: <Widget>[
          // Botón de búsqueda en la barra de aplicación
          IconButton(
            icon: iconSearch,
            onPressed: () {
              setState(() {
                if (iconSearch.icon == Icons.search) {
                  iconSearch = const Icon(Icons.cancel);
                  cusSearch = Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.go,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Buscar experto aquí...',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 3.0,
                          ),
                        ),
                      ),
                      onChanged: (text) {
                        setState(
                            () {}); // Redibuja la vista al cambiar el texto
                      },
                    ),
                  );
                } else {
                  iconSearch = const Icon(Icons.search);
                  cusSearch = const Text("Expertos en mantenimiento");
                  _searchController
                      .clear(); // Limpia el campo de búsqueda al cancelar
                }
              });
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getExpertoDetalle(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Transform.scale(
                scale: 0.7,
                child: const CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final expertos = snapshot.data;
            if (expertos != null && expertos.isNotEmpty) {
              // Filtrar expertos basados en el texto de búsqueda
              String searchTerm = _searchController.text.toLowerCase();
              List<Experto> expertosFiltrados =
                  filtrarExpertos(expertos, searchTerm);

              // Lista de expertos con posibilidad de búsqueda y asignación de electrodomésticos
              return ListView(
                children: expertosFiltrados.map((expert) {
                  return ExpansionTile(
                    leading: const Icon(Icons.engineering_sharp),
                    title: Text(expert.name),
                    subtitle: Text(
                        "Correo: ${expert.email} \nTeléfono: ${expert.phone}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón para asignar electrodoméstico
                        IconButton(
                          icon: const Icon(Icons.devices),
                          onPressed: () {
                            expertId = expert.id;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildAssignApplianceDialog(context);
                              },
                            );
                          },
                        ),
                        // Botón para llamar al experto
                        IconButton(
                          icon: const Icon(Icons.call),
                          onPressed: () async {
                            await FlutterPhoneDirectCaller.callNumber(
                                expert.phone);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            } else {
              return const Center(child: Text('No se encontraron expertos.'));
            }
          }
        },
      ),
    );
  }

  // Construye el diálogo para asignar electrodoméstico a experto
  Widget _buildAssignApplianceDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Asignar experto'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dropdown para seleccionar electrodoméstico
              if (items.isNotEmpty)
                DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Text(
                    'Seleccione electrodomestico',
                    style: TextStyle(fontSize: 14, color: Colors.black),
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
            ],
          );
        },
      ),
      actions: <Widget>[
        // Botón para cerrar el diálogo
        TextButton(
          onPressed: () {
            selectedAppliance = null;
            Navigator.of(context).pop(); // Cerrar el AlertDialog
          },
          child: const Text('Cerrar'),
        ),
        // Botón para asignar electrodoméstico al experto
        if (items.isNotEmpty)
          TextButton(
            onPressed: () async {
              if (selectedAppliance != null) {
                try {
                  String applianceId =
                      await getElectrodomesticoId(selectedAppliance!, uid);
                  // Realiza la asignación del electrodoméstico al experto aquí
                  asignarExperto(applianceId, expertId);
                  selectedAppliance = null;
                  // Cierra el cuadro de diálogo
                  showPersonalizedAlert(
                      context,
                      "Electrodomestico asignado correctamente",
                      AlertMessageType.notification);
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error al obtener el ID del electrodoméstico: $e');
                }
              } else {
                print('Ningún electrodoméstico seleccionado.');
              }
            },
            child: const Text('Asignar'),
          ),
      ],
    );
  }
}

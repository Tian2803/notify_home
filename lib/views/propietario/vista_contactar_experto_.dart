// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/controller_electrodomestico.dart';
import 'package:notify_home/controllers/controlador_experto.dart';
import 'package:notify_home/models/experto.dart';

class ContactarExperto extends StatefulWidget {
  const ContactarExperto({Key? key}) : super(key: key);

  @override
  State<ContactarExperto> createState() => _ContactarExpertoState();
}

class _ContactarExpertoState extends State<ContactarExperto> {
  Icon iconSearch = const Icon(Icons.search);
  Widget cusSearch = const Text("Expertos");
  final TextEditingController _searchController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  String? selectedAppliance;
  late List<String> items;
  late String expertId;

  @override
  void initState() {
    super.initState();
    items = [];
    _loadAppliances();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: cusSearch,
        actions: <Widget>[
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
        future: getExpertoDetails(),
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
                  filterExpertos(expertos, searchTerm);

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

  Widget _buildAssignApplianceDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Electrodoméstico'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                try {
                  String applianceId =
                      await getApplianceId(selectedAppliance!, uid);
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

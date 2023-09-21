// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:notify_home/controllers/controller_appliance.dart';
import 'package:notify_home/controllers/controller_edit_appliance.dart';
import 'package:notify_home/controllers/controller_register_appliance.dart';
import 'package:notify_home/models/appliance.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  final user = Container(
    margin: const EdgeInsets.only(
      top: 30.0, bottom: 20
    ),
    width: 100.0,
    height: 100.0,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.cover, image: NetworkImage("https://th.bing.com/th/id/OIP.EvZTZb4KMBsXT4RiH5DVpgHaE8?pid=ImgDet&w=474&h=316&rs=1"))),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Asignamos la clave al Scaffold
      drawer: Drawer(
        child: Container(
          color: Colors.blue,
          child: Column(children: [
            user,
            const Text("Jaegersian",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              color: Colors.lightBlue[400],
              child: const Text("Calendario"),
            )
          ]),
        ),
      ),
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _openDrawer();
            },
          ),
          title: const Text('Mis Equipos')),
      body: ListView(
        children: [
          FutureBuilder<List<Appliance>>(
            future: getApplianceDetails(uid),
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
                final appliances = snapshot.data;
                if (appliances != null && appliances.isNotEmpty) {
                  return Column(
                    children: appliances.map((appliance) {
                      return ExpansionTile(
                        leading: const Icon(Icons.devices),
                        title: Text(appliance.name),
                        subtitle: Text(appliance.place),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ApplianceEditController(
                                              appliance: appliance)),
                                );
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                deleteAppliance(appliance);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        children: [
                          ListTile(
                            title: Text(
                                "Tiempo de uso: ${appliance.useTime} horas"),
                            subtitle: Text(
                                "Frecuencia de uso: ${appliance.frequency}"),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                } else {
                  return const Text('No se encontraron electrodomésticos.');
                }
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Agrega la funcionalidad para el botón flotante aquí.
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ApplianceRegisterController()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

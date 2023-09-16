import 'package:flutter/material.dart';
import 'package:notify_home/controllers/controller_appliance.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // menu desplegable
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
                        children: [Text("Tiempo de uso: ${appliance.useTime}"),
                          Text("Frecuencia de uso: ${appliance.frequency}"),
                          Text("Descripcion: ${appliance.description}")],
                        // Aquí debes colocar el contenido adicional que se mostrará al expandir
                        //children: [
                          // Puedes agregar más widgets aquí para mostrar detalles adicionales
                          
                          
                          // Agrega cualquier otra información adicional que desees mostrar
                        //],
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

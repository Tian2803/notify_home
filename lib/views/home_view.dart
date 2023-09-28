// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:notify_home/controllers/controller_appliance.dart';
import 'package:notify_home/controllers/controller_edit_appliance.dart';
import 'package:notify_home/controllers/controller_login.dart';
import 'package:notify_home/controllers/controller_register_appliance.dart';
import 'package:notify_home/controllers/controller_user.dart';
import 'package:notify_home/models/appliance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';
import 'package:notify_home/views/calendar_view.dart';

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

  Future<String?> nameUser = getUserName();
  final email = FirebaseAuth.instance.currentUser!.email;

  final user = Container(
    margin: const EdgeInsets.only(top: 30.0, bottom: 20),
    width: 100.0,
    height: 100.0,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                "https://th.bing.com/th/id/OIP.EvZTZb4KMBsXT4RiH5DVpgHaE8?pid=ImgDet&w=474&h=316&rs=1"))),
  );

  final signOut = Container(
    margin: const EdgeInsets.only(top: 4),
    padding: const EdgeInsets.all(10),
    width: double.infinity,
    color: const Color.fromARGB(209, 127, 206, 243),
    child: const Text(
      "Cerrar sesion",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
  //Aqui va la  hoja de
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Asignamos la clave al Scaffold
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: FutureBuilder<String?>(
              future: getUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('Usuario no autenticado o sin nombre.');
                } else {
                  final userName = snapshot.data;
                  return Text(
                    'Username: $userName',
                    style: const TextStyle(color: Colors.white),
                  );
                }
              },
            ),
            accountEmail: Text(
              "$email",
              style: const TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://th.bing.com/th/id/OIP.EvZTZb4KMBsXT4RiH5DVpgHaE8?pid=ImgDet&w=474&h=316&rs=1',
                  width: 90, // Ajusta el ancho según tus necesidades
                  height: 90, // Ajusta la altura según tus necesidades
                  fit: BoxFit
                      .cover, // Ajusta la forma en que la imagen se adapta al círculo
                ),
              ),
            ),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/images/fondo.png"),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text("Calendario de mantenimiento"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarNotify()),
              );
            },
          ),
          Expanded(child: Container()),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Cerrar sesion"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginController()),
              );
            },
          )
        ],
      )),
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
                      return ListTile(
                        leading: const Icon(Icons.devices),
                        title: Text(appliance.name),
                        //subtitle: Text(hve.fabricante),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /*IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ApplianceEditController(
                                              appliance: appliance, hve: null,)),
                                );
                                setState(() {});
                              },
                            ),*/
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                deleteAppliance(appliance);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
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

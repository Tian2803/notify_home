// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:notify_home/controllers/controller_electrodomestico.dart';
import 'package:notify_home/controllers/controller_edit_electrodomestico.dart';
import 'package:notify_home/controllers/controller_hoja_vida_electrodomestico.dart';
import 'package:notify_home/controllers/login_controller.dart';
import 'package:notify_home/controllers/controller_propietario.dart';
import 'package:notify_home/models/electrodomestico.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';
import 'package:notify_home/views/propietario/vista_registro_electrodomestico.dart';
import 'package:notify_home/views/vista_calendario.dart';
import 'package:notify_home/views/propietario/vista_contactar_experto_.dart';
import 'package:notify_home/views/vista_mostrar_hoja_vida.dart';

class HomeViewUser extends StatefulWidget {
  const HomeViewUser({Key? key});

  @override
  State<HomeViewUser> createState() => _HomeViewUserState();
}

class _HomeViewUserState extends State<HomeViewUser> {
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
      backgroundColor: Colors.white,
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
                    '$userName',
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
                    image: AssetImage("assets/images/fondo.png"),
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
          ListTile(
              leading: const Icon(Icons.person_search_rounded),
              title: const Text("Contactar experto"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactarExperto()));
              }),
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
          title: const Text("Mis Equipos")),
      body: ListView(
        children: [
          FutureBuilder<List<Electrodomestico>>(
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
                        title:
                            Text("${appliance.name} ${appliance.fabricante}"),
                        subtitle: Text("Experto: ${appliance.expertoId}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: const Icon(Icons.visibility_outlined),
                                onPressed: () async {
                                  try {
                                    HojaVidaElectrodomestico hojaVid =
                                        await getHojaVidaDetails(
                                            uid, appliance.id);
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HojaVidaShowView(
                                                    hojaVida: hojaVid)));
                                    setState(() {});
                                  } catch (e) {
                                    // Maneja la excepción, por ejemplo, mostrando un mensaje de error.
                                    print(
                                        'Error al obtener detalles de la hoja de vida: $e');
                                  }
                                }),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ApplianceEditController(
                                            appliance: appliance,
                                          )),
                                );
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                HojaVidaElectrodomestico hojaVida =
                                    await getHojaVidaDetails(uid, appliance.id);
                                deleteAppliance(appliance);
                                deleteHojaVida(hojaVida);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        children: [
                          ListTile(
                            title: Text("Modelo: ${appliance.modelo}"),
                            subtitle: Text("Calificacion energetica: ${appliance.calificacionEnergetica}"),
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
                builder: (context) => const ApplianceRegisterView()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:notify_home/controllers/hoja_vida_edit_controller.dart';
import 'package:notify_home/controllers/electrodomestico_controller.dart';
import 'package:notify_home/controllers/experto_controller.dart';
import 'package:notify_home/controllers/hoja_vida_controller.dart';
import 'package:notify_home/controllers/login_controller.dart';
import 'package:notify_home/models/electrodomestico.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';
import 'package:notify_home/views/vista_calendario.dart';
import 'package:notify_home/views/vista_mostrar_hoja_vida.dart';

class HomeViewExpert extends StatefulWidget {
  const HomeViewExpert({Key? key});

  @override
  State<HomeViewExpert> createState() => _HomeViewExpertState();
}

class _HomeViewExpertState extends State<HomeViewExpert> {
  // ID del usuario actual.
  final uid = FirebaseAuth.instance.currentUser!.uid;

  // Clave global para el Scaffold.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Método para abrir el Drawer.
  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  // Obtener el nombre del usuario.
  Future<String?> nameUser = getNombreUsuarioExperto();

  // Datos del usuario actual.
  final email = FirebaseAuth.instance.currentUser!.email;

  // Widget de la imagen del usuario.
  final user = Container(
    margin: const EdgeInsets.only(top: 30.0, bottom: 20),
    width: 100.0,
    height: 100.0,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        fit: BoxFit.cover,
        image: NetworkImage(
          "https://th.bing.com/th/id/OIP.EvZTZb4KMBsXT4RiH5DVpgHaE8?pid=ImgDet&w=474&h=316&rs=1",
        ),
      ),
    ),
  );

  // Widget del botón para cerrar sesión.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey, // Asignamos la clave al Scaffold
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Encabezado del Drawer con información del usuario.
            UserAccountsDrawerHeader(
              accountName: FutureBuilder<String?>(
                future: getNombreUsuarioExperto(),
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
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Elementos del Drawer.
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Gestionar mantenimiento",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 74, 10, 80),
                ),
              ),
            ),
            const Divider(
              height: 0.5,
              thickness: 0.3,
              color: Colors.grey,
            ),
            // Opción de ver el calendario de mantenimiento.
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("Calendario de mantenimiento"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalendarNotify(),
                  ),
                );
              },
            ),
            // Espacio expansivo para estirar los elementos al final.
            Expanded(child: Container()),
            // Opción para cerrar sesión.
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Cerrar sesion"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginController(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _openDrawer();
          },
        ),
        title: const Text('Equipos asignados'),
      ),
      body: ListView(
        children: [
          // Listar electrodomésticos asignados al experto.
          FutureBuilder<List<Electrodomestico>>(
            future: getElectrodomesticoDetalleExperto(uid),
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
                      // ExpansionTile para cada electrodoméstico.
                      return ExpansionTile(
                        leading: const Icon(Icons.devices),
                        title: Text(appliance.name),
                        subtitle: Text(appliance.fabricante),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botón para ver detalles de la hoja de vida.
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined),
                              onPressed: () async {
                                try {
                                  HojaVidaElectrodomestico hojaVid =
                                      await getHojaVidaElectrodomesticoDetalle(
                                          appliance.user, appliance.id);
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HojaVidaShowView(
                                        hojaVida: hojaVid,
                                      ),
                                    ),
                                  );

                                  setState(() {});
                                } catch (e) {
                                  // Maneja la excepción, por ejemplo, mostrando un mensaje de error.
                                  print(
                                    'Error al obtener detalles de la hoja de vida: $e',
                                  );
                                }
                              },
                            ),
                            // Botón para editar la hoja de vida.
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                try {
                                  String id = await getIdPropietario(uid);
                                  print("User id: $id");

                                  HojaVidaElectrodomestico hojaVid =
                                      await getHojaVidaElectrodomesticoExpertoDetalle(
                                          id, appliance.id);
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HVEditController(
                                        appliance: appliance,
                                        hve: hojaVid,
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                } catch (e) {
                                  // Maneja la excepción, por ejemplo, mostrando un mensaje de error.
                                  print(
                                    'Error al obtener detalles de la hoja de vida: $e',
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        children: [
                          ListTile(
                            title: Text("Modelo: ${appliance.modelo}"),
                            subtitle: Text(
                              "Calificacion energetica: ${appliance.calificacionEnergetica}",
                            ),
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
    );
  }
}

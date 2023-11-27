// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:notify_home/controllers/electrodomestico_controller.dart';
import 'package:notify_home/controllers/electrodomestico_edit_controller.dart';
import 'package:notify_home/controllers/hoja_vida_controller.dart';
import 'package:notify_home/controllers/login_controller.dart';
import 'package:notify_home/controllers/propietario_controller.dart';
import 'package:notify_home/models/electrodomestico.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';
import 'package:notify_home/views/propietario/vista_registro_electrodomestico.dart';
import 'package:notify_home/views/vista_calendario.dart';
import 'package:notify_home/views/propietario/vista_contactar_experto_.dart';
import 'package:notify_home/views/vista_mostrar_hoja_vida.dart';
import 'package:notify_home/views/vista_predecir.dart';

class HomeViewUser extends StatefulWidget {
  const HomeViewUser({Key? key});

  @override
  State<HomeViewUser> createState() => _HomeViewUserState();
}

class _HomeViewUserState extends State<HomeViewUser> {
  // ID del usuario actual.
  final uid = FirebaseAuth.instance.currentUser!.uid;

  // Clave global para el Scaffold.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Método para abrir el Drawer.
  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  // Obtener el nombre del propietario.
  Future<String?> nameUser = getNombrePropietario();

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
                future: getNombrePropietario(),
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
            // Opción de contactar a un experto.
            ListTile(
              leading: const Icon(Icons.person_search_rounded),
              title: const Text("Contactar experto"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactarExperto(),
                  ),
                );
              },
            ),
            // Opción para programar mantenimiento.
            ListTile(
              leading: const Icon(Icons.date_range_rounded),
              title: const Text("Programar mantenimiento"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VistaPrediccion(),
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
        title: const Text("Mis Equipos"),
      ),
      body: ListView(
        children: [
          // Listar electrodomésticos del propietario.
          FutureBuilder<List<Electrodomestico>>(
            future: getElectrodomesticoDetalle(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga si los datos aún no están disponibles.
                return Center(
                  child: Transform.scale(
                    scale: 0.7,
                    child: const CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                // Muestra un mensaje de error si hay un problema al obtener los datos.
                return Text('Error: ${snapshot.error}');
              } else {
                // Si se obtienen datos, mostrar la lista de electrodomésticos.
                final appliances = snapshot.data;
                if (appliances != null && appliances.isNotEmpty) {
                  return Column(
                    children: appliances.map((appliance) {
                      // Expansión de cada electrodoméstico.
                      return ExpansionTile(
                        leading: const Icon(Icons.devices),
                        title:
                            Text("${appliance.name} ${appliance.fabricante}"),
                        subtitle: Text("Experto: ${appliance.expertoId}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botón para ver la hoja de vida del electrodoméstico.
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined),
                              onPressed: () async {
                                try {
                                  // Obtener y mostrar la hoja de vida del electrodoméstico.
                                  HojaVidaElectrodomestico hojaVid =
                                      await getHojaVidaElectrodomesticoDetalle(
                                          uid, appliance.id);
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
                                  // Manejar la excepción, por ejemplo, mostrar un mensaje de error.
                                  print(
                                    'Error al obtener detalles de la hoja de vida: $e',
                                  );
                                }
                              },
                            ),
                            // Botón para editar el electrodoméstico.
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ApplianceEditController(
                                      electrodomestico: appliance,
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                            ),
                            // Botón para eliminar el electrodoméstico y su hoja de vida asociada.
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                HojaVidaElectrodomestico hojaVida =
                                    await getHojaVidaElectrodomesticoDetalle(
                                        uid, appliance.id);
                                eliminarElectrodomestico(appliance);
                                eliminarHojaVidaElectrodomestico(hojaVida);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        children: [
                          ListTile(
                            title: Text("Modelo: ${appliance.modelo}"),
                            subtitle: Text(
                                "Calificacion energetica: ${appliance.calificacionEnergetica}"),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                } else {
                  // Mensaje si no se encuentran electrodomésticos.
                  return const Text('No se encontraron electrodomésticos.');
                }
              }
            },
          ),
        ],
      ),
      // Botón flotante para agregar un nuevo electrodoméstico.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navegar a la vista de registro de electrodomésticos.
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ApplianceRegisterView(),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      // Posición del botón flotante.
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

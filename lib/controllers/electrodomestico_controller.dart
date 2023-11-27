// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, use_build_context_synchronously
// Importaciones de paquetes y archivos necesarios
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/experto_controller.dart';
import 'package:notify_home/models/electrodomestico.dart';

Future<List<Electrodomestico>> getElectrodomesticoDetalle(String applianceId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Realiza la consulta a Firebase Firestore
    QuerySnapshot snapshot = await firestore
        .collection('electrodomestico')
        .where('user', isEqualTo: applianceId)
        .get();

    // Inicializa una lista para almacenar los electrodomésticos
    List<Electrodomestico> appliances = [];

    // Recorre los documentos y crea instancias de la clase Electrodomestico
    for (var doc in snapshot.docs) {
      // Obtiene el nombre del experto asociado al electrodoméstico
      String? expertName = await getNombreExperto(doc['expertoId']);
      
      // Crea una instancia de la clase Electrodomestico
      appliances.add(Electrodomestico(
        id: doc.id,
        name: doc['name'],
        fabricante: doc['fabricante'],
        modelo: doc['modelo'],
        calificacionEnergetica: doc['calificacionEnergetica'],
        user: doc['user'],
        expertoId: expertName,
      ));
    }
    
    // Devuelve la lista de electrodomésticos
    return appliances;
  } catch (e) {
    // Maneja errores de forma adecuada
    print('Error, no se logró obtener la información de los electrodomésticos: $e');
    throw Exception(
        'No se pudo obtener la información de los electrodomésticos.');
  }
}

// Función para actualizar un electrodoméstico
void actualizarElectrodomestico(Electrodomestico appliance) {
  // Obtén una referencia al documento del electrodoméstico en Firestore
  DocumentReference applianceRef = FirebaseFirestore.instance
      .collection('electrodomestico')
      .doc(appliance.id);

  // Actualiza los campos del electrodoméstico en Firestore
  applianceRef.update({
    'name': appliance.name,
    'fabricante': appliance.fabricante,
    'modelo': appliance.modelo,
    'calificacionEnergetica': appliance.calificacionEnergetica,
  }).then((_) {
    print('Electrodomestico actualizado correctamente');
  }).catchError((error) {
    print('Error al actualizar el electrodomestico: $error');
  });
}

// Función para eliminar un electrodoméstico
void eliminarElectrodomestico(Electrodomestico appliance) {
  // Obtén una referencia al documento del electrodoméstico en Firestore
  DocumentReference applianceRef = FirebaseFirestore.instance
      .collection('electrodomestico')
      .doc(appliance.id);

  // Elimina el documento del electrodoméstico en Firestore
  applianceRef.delete().then((doc) {
    print("Electrodomestico eliminado correctamente");
  }).catchError((error) {
    print('Error al eliminar el electrodomestico: $error');
  });
}

// Función para registrar un electrodoméstico
void registrarElectrodomestico(BuildContext context, String nombreElectrodomestico, String fabricante,
    String modelo, String calificacionEnergetica, String applianceId) async {
  try {
    // Verifica que los campos requeridos no estén vacíos
    if (nombreElectrodomestico.isEmpty ||
        fabricante.isEmpty ||
        modelo.isEmpty ||
        calificacionEnergetica.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, llene todos los campos',
          AlertMessageType.warning);
    }

    // Obtiene el ID del usuario actual
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Crea una instancia de la clase Electrodomestico
    Electrodomestico appliance = Electrodomestico(
      id: applianceId,
      name: nombreElectrodomestico,
      fabricante: fabricante,
      modelo: modelo,
      calificacionEnergetica: calificacionEnergetica,
      user: uid,
      expertoId: '""',
    );

    // Guarda el electrodoméstico en Firestore
    await FirebaseFirestore.instance
        .collection('electrodomestico')
        .doc(applianceId)
        .set(appliance.toJson());
  } catch (e) {
    // Muestra una alerta en caso de error
    showPersonalizedAlert(context, 'Error al registrar el electrodomestico',
        AlertMessageType.error);
  }
}

// Función para obtener nombres de electrodomésticos
Future<List<String>> getElectrodomesticoNombre(String userId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Realiza la consulta a Firebase Firestore
    QuerySnapshot snapshot = await firestore
        .collection('electrodomestico')
        .where('user', isEqualTo: userId)
        .get();

    // Inicializa una lista para almacenar los nombres de los electrodomésticos
    List<String> appliance = [];
    // Recorre los documentos y agrega los nombres a la lista
    snapshot.docs.forEach((doc) {
      var name = doc['name'];
      appliance.add(name);
    });

    // Devuelve la lista de nombres
    return appliance;
  } catch (e) {
    // Maneja errores de forma adecuada
    throw Exception(
        'No se pudo obtener la información de los electrodomésticos.');
  }
}

// Función para asignar un experto a un electrodoméstico
void asignarExperto(String appliance, String expertId) {
  // Obtén una referencia al documento del electrodoméstico en Firestore
  DocumentReference applianceRef =
      FirebaseFirestore.instance.collection('electrodomestico').doc(appliance);

  // Actualiza los campos del electrodoméstico en Firestore
  applianceRef.update({
    'expertoId': expertId,
  }).then((_) {
    print('Experto asignado correctamente');
  }).catchError((error) {
    print('Error al asignar experto: $error');
  });
}

// Función para obtener el ID de un electrodoméstico por su nombre y usuario
Future<String> getElectrodomesticoId(String electrodomesticoNombre, String userId) async {
  try {
    // Realiza la consulta a Firebase Firestore
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('electrodomestico')
        .where('name', isEqualTo: electrodomesticoNombre)
        .where('user', isEqualTo: userId)
        .get();

    // Obtiene el ID del electrodoméstico
    final applianceId = querySnapshot.docs.first.id;
    
    // Devuelve el id del electrodomestico
    return applianceId;
  } catch (e) {
    throw Exception(
        'No se pudo obtener el identificador del electrodoméstico.');
  }
}

// Función para obtener detalles de electrodomésticos por experto
Future<List<Electrodomestico>> getElectrodomesticoDetalleExperto(
    String expertId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Realiza la consulta a Firebase Firestore
    QuerySnapshot snapshot = await firestore
        .collection('electrodomestico')
        .where('expertoId', isEqualTo: expertId)
        .get();

    // Inicializa una lista para almacenar los electrodomésticos
    List<Electrodomestico> appliances = [];
    // Recorre los documentos y crea instancias de la clase Electrodomestico
    snapshot.docs.forEach((doc) {
      appliances.add(Electrodomestico(
        id: doc.id,
        name: doc['name'],
        fabricante: doc['fabricante'],
        modelo: doc['modelo'],
        calificacionEnergetica: doc['calificacionEnergetica'],
        user: doc['user'],
        expertoId: doc['expertoId'],
      ));
    });
    // Devuelve la lista de electrodomésticos
    return appliances;
  } catch (e) {
    // Maneja errores de forma adecuada
    print(
        'Error, no se logró obtener la información de los electrodomésticos: $e');
    throw Exception(
        'No se pudo obtener la información de los electrodomésticos.');
  }
}

// Función para obtener el ID del propietario por ID de experto
Future<String> getIdPropietario(String idExperto) async {
  try {
    // Realiza la consulta a Firebase Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('electrodomestico')
        .where('expertoId', isEqualTo: idExperto)
        .get();

    // Obtiene el ID del propietario
    final userName = userDoc.docs.first['user'];
    // Imprime el ID del propietario (puede eliminarse en producción)
    print(userName);
    return userName;
  } catch (e) {
    throw Exception('No se pudo obtener el nombre del usuario.');
  }
}

// Función para obtener nombres de electrodomésticos por ID de experto
Future<List<String>> getElectrodomesticoNombreExperto(String expertoId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Realiza la consulta a Firebase Firestore
    QuerySnapshot snapshot = await firestore
        .collection('electrodomestico')
        .where('expertoId', isEqualTo: expertoId)
        .get();

    // Inicializa una lista para almacenar los nombres de los electrodomésticos
    List<String> appliance = [];
    // Recorre los documentos y agrega los nombres a la lista
    snapshot.docs.forEach((doc) {
      var name = doc['name'];
      appliance.add(name);
    });

    // Imprime la lista de nombres (puede eliminarse en producción)
    print(appliance);
    return appliance;
  } catch (e) {
    print('Error al obtener información de electrodomésticos: $e');
    throw Exception(
        'No se pudo obtener la información de los electrodomésticos.');
  }
}

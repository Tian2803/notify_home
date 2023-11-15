// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, use_build_context_synchronously

//YA FUNCIONA BIEN
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/controlador_experto.dart';
import 'package:notify_home/models/electrodomestico.dart';

Future<List<Electrodomestico>> getApplianceDetails(String applianceId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Realiza la consulta a Firebase Firestore
    QuerySnapshot snapshot = await firestore
        .collection('electrodomestico')
        .where('user', isEqualTo: applianceId)
        .get();

    // Inicializa una lista para almacenar los electrodomésticos
    List<Electrodomestico> appliances = [];
    // Recorre los documentos y crea instancias de la clase Appliance
    for (var doc in snapshot.docs) {
      String? expertName = await getExpertoName(doc['expertoId']);
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
    print(
        'Error, no se logro obtener la información de los electrodomésticos: $e');
    throw Exception(
        'No se pudo obtener la información de los electrodomésticos.');
  }
}

void updateAppliance(Electrodomestico appliance) {
  // Obtén una referencia al documento del producto en Firestore
  DocumentReference applianceRef = FirebaseFirestore.instance
      .collection('electrodomestico')
      .doc(appliance.id);

  // Actualiza los campos del producto en Firestore
  applianceRef.update({
    'name': appliance.name,
    'fabricante': appliance.fabricante,
    'modelo': appliance.modelo,
    'tipo': appliance.calificacionEnergetica,
  }).then((_) {
    print('Electrodomestico actualizado correctamente');
  }).catchError((error) {
    print('Error al actualizar el electrodomestico: $error');
  });
}

void deleteAppliance(Electrodomestico appliance) {
  DocumentReference applianceRef = FirebaseFirestore.instance
      .collection('electrodomestico')
      .doc(appliance.id);

  applianceRef.delete().then((doc) {
    print("Electrodomesticos eliminado correctamente");
  }).catchError((error) {
    print('Error al eliminar el electrodomestico: $error');
  });
}

void registerAppliance(BuildContext context, String name, String fabricante,
    String modelo, String calificacionEnergetica, String applianceId) async {
  try {
    if (name.isEmpty ||
        fabricante.isEmpty ||
        modelo.isEmpty ||
        calificacionEnergetica.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, llene todos los campos',
          AlertMessageType.warning);
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;

    Electrodomestico appliance = Electrodomestico(
      id: applianceId,
      name: name,
      fabricante: fabricante,
      modelo: modelo,
      calificacionEnergetica: calificacionEnergetica,
      user: uid,
      expertoId: '""',
    );

    await FirebaseFirestore.instance
        .collection('electrodomestico')
        .doc(applianceId)
        .set(appliance.toJson());
  } catch (e) {
    showPersonalizedAlert(context, 'Error al registrar el electrodomestico',
        AlertMessageType.error);
  }
}

Future<List<String>> getApplianceWithInfo(String userId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot snapshot = await firestore
        .collection('electrodomestico')
        .where('user', isEqualTo: userId)
        .get();

    List<String> appliance = [];
    snapshot.docs.forEach((doc) {
      var name = doc['name'];
      appliance.add(name);
    });

    print(appliance);
    return appliance;
  } catch (e) {
    print('Error al obtener información de electrodomésticos: $e');
    throw Exception(
        'No se pudo obtener la información de los electrodomésticos.');
  }
}

void asignarExperto(String appliance, String expertId) {
  // Obtén una referencia al documento del producto en Firestore
  DocumentReference applianceRef =
      FirebaseFirestore.instance.collection('electrodomestico').doc(appliance);

  // Actualiza los campos del producto en Firestore
  applianceRef.update({
    'expertoId': expertId,
  }).then((_) {
    print('Experto asignado correctamente');
  }).catchError((error) {
    print('Error al asignar experto: $error');
  });
}

Future<String> getApplianceId(String applianceName, String userId) async {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('electrodomestico')
        .where('name', isEqualTo: applianceName)
        .where('user', isEqualTo: userId)
        .get();

    final applianceId = querySnapshot.docs.first.id;
    print(applianceId);
    return applianceId;
    // No se encontró el electrodoméstico con el nombre proporcionado
  } catch (e) {
    throw Exception(
        'No se pudo obtener el identificador del electrodoméstico.');
  }
}

Future<List<Electrodomestico>> getApplianceDetailsExperto(
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
    // Recorre los documentos y crea instancias de la clase Appliance
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
        'Error, no se logro obtener la información de los electrodomésticos: $e');
    throw Exception(
        'No se pudo obtener la información de los electrodomésticos.');
  }
}

Future<String> getIdPropietario(String idExperto) async {
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('electrodomestico')
        .where('expertoId', isEqualTo: idExperto)
        .get();

    final userName = userDoc.docs.first['user'];
    print(userName);
    return userName;
  } catch (e) {
    throw Exception('No se pudo obtener el nombre del usuario.');
  }
}

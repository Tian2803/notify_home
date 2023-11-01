// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, use_build_context_synchronously

//YA FUNCIONA BIEN
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/models/appliance.dart';

Future<List<Appliance>> getApplianceDetails(String applianceId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Realiza la consulta a Firebase Firestore
    QuerySnapshot snapshot = await firestore
        .collection('electrodomestico')
        .where('user', isEqualTo: applianceId)
        .get();

    // Inicializa una lista para almacenar los electrodomésticos
    List<Appliance> appliances = [];
    // Recorre los documentos y crea instancias de la clase Appliance
    snapshot.docs.forEach((doc) {
      appliances.add(Appliance(
        id: doc.id,
        name: doc['name'],
        fabricante: doc['fabricante'],
        modelo: doc['modelo'],
        tipo: doc['tipo'],
        user: doc['user'],
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

void updateAppliance(Appliance appliance) {
  // Obtén una referencia al documento del producto en Firestore
  DocumentReference applianceRef = FirebaseFirestore.instance
      .collection('electrodomestico')
      .doc(appliance.id);

  // Actualiza los campos del producto en Firestore
  applianceRef.update({
    'name': appliance.name,
    'fabricante': appliance.fabricante,
    'modelo': appliance.modelo,
    'tipo': appliance.tipo,
  }).then((_) {
    print('Electrodomestico actualizado correctamente');
  }).catchError((error) {
    print('Error al actualizar el electrodomestico: $error');
  });
}

void deleteAppliance(Appliance appliance) {
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
    String modelo, String tipo, String applianceId) async {
  try {
    if (name.isEmpty || fabricante.isEmpty || modelo.isEmpty || tipo.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, llene todos los campos',
          AlertMessageType.warning);
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;

    Appliance appliance = Appliance(
      id: applianceId,
      name: name,
      fabricante: fabricante,
      modelo: modelo,
      tipo: tipo,
      user: uid,
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

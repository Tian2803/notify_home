// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
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
        marca: doc['marca'],
        modelo: doc['modelo'],
        tipo: doc['tipo'],
        user: doc['user'],
      ));
    });
    // Devuelve la lista de electrodomésticos
    return appliances;
  } catch (e) {
    // Maneja errores de forma adecuada
    print('Error, no se logro obtener la información de los electrodomésticos: $e');
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
    'marca': appliance.marca,
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

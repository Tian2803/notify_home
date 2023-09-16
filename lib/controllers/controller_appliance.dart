// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notify_home/models/appliance.dart';

Future<List<Appliance>> getApplianceDetails(String applianceId) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('electrodomesticos')
        .where('user', isEqualTo: applianceId)
        .get();

    List<Appliance> appliances = [];

    snapshot.docs.forEach((doc) {
      appliances.add(Appliance(
        id: doc.id,
        name: doc['name'],
        place: doc['place'],
        useTime: doc['useTime'],
        frequency: doc['frequency'],
        description: doc['description'],
        user: doc['user'],
      ));
    });
    return appliances;
  } catch (e) {
    throw Exception('Error al obtener la información de los electrodomésticos en la base de datos');
  }
}

void updateProduct(Appliance appliance) {
  // Obtén una referencia al documento del producto en Firestore
  DocumentReference applianceRef = FirebaseFirestore.instance
      .collection('electrodomesticos')
      .doc(appliance.id);

  // Actualiza los campos del producto en Firestore
  applianceRef.update({
    'name': appliance.name,
    'place': appliance.place,
    'useTime': appliance.useTime,
    'frequency': appliance.frequency,
    'description': appliance.description,
  }).then((_) {
    print('Electrodomestico actualizado correctamente');
  }).catchError((error) {
    print('Error al actualizar el producto: $error');
  });
}



// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notify_home/models/appliance.dart';
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';

Future<List<HojaVidaElectrodomestico>> getHVEDetails(String hjeId) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('hojaVidaElectrodomestico')
        .where('user', isEqualTo: hjeId)
        .get();

    List<HojaVidaElectrodomestico> hojaVE = [];

    snapshot.docs.forEach((doc) {
      hojaVE.add(HojaVidaElectrodomestico(
        id: doc.id,
        condicionAmbiental: doc['condicionAmbiental'],
        fechaCompra: doc['fechaCompra'],
        fechaInstalacion: doc['fechaInstalacion'],
        fechaMManual: doc['fechaMManual'],
        fechaUltMantenimiento: doc['fechaUltMantenimiento'],
        tiempoUso: doc['tiempoUso'],
        frecuenciaUso: doc['frecuenciaUso'],
        ubicacion: doc['ubicacion'],
        user: doc['user'],
      ));
    });
    return hojaVE;
  } catch (e) {
    throw Exception(
        'Error al obtener la información de los electrodomésticos en la base de datos');
  }
}

void updateHJAppliance(HojaVidaElectrodomestico hve) {
  // Obtén una referencia al documento del producto en Firestore
  DocumentReference applianceRef = FirebaseFirestore.instance
      .collection('hojaVidaElectrodomestico')
      .doc(hve.id);

  // Actualiza los campos del producto en Firestore
  applianceRef.update({
    'condicionAmbiental' : hve.condicionAmbiental,
        'fechaCompra': hve.fechaCompra,
        'fechaInstalacion': hve.fechaInstalacion,
        'fechaMManual': hve.fechaMManual,
       'fechaUltMantenimiento': hve.fechaUltMantenimiento,
        'tiempoUso': hve.tiempoUso,
        'frecuenciaUso':hve.tiempoUso,
        'ubicacion': hve.ubicacion,
  }).then((_) {
    print('Electrodomestico actualizado correctamente');
  }).catchError((error) {
    print('Error al actualizar el electrodomestico: $error');
  });
}

void deleteAppliance(Appliance appliance) {
  DocumentReference applianceRef = FirebaseFirestore.instance
      .collection('electrodomesticos')
      .doc(appliance.id);

  applianceRef.delete().then((doc) {
    print("Electrodomesticos eliminado correctamente");
  }).catchError((error) {
    print('Error al eliminar el electrodomestico: $error');
  });
}

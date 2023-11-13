// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';

Future<HojaVidaElectrodomestico> getHojaVidaDetails(
    String idUser, String idAppliance) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    QuerySnapshot snapshot = await firestore
        .collection('hojaVidaElectrodomestico')
        .where('user', isEqualTo: idUser)
        .where('id', isEqualTo: idAppliance)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc =
          snapshot.docs.first; // Obtén el primer documento del QuerySnapshot

      return HojaVidaElectrodomestico(
        id: doc.id,
        condicionAmbiental: doc['condicionAmbiental'],
        fechaCompra: DateTime.parse(doc['fechaCompra']),
        fechaInstalacion: DateTime.parse(doc['fechaInstalacion']),
        fechaMManual: DateTime.parse(doc['fechaMManual']),
        fechaUltMantenimiento: DateTime.parse(doc['fechaUltMantenimiento']),
        tiempoUso: doc['tiempoUso'],
        frecuenciaUso: doc['frecuenciaUso'],
        ubicacion: doc['ubicacion'],
        user: doc['user'],
      );
    } else {
      throw Exception(
          'No se encontraron registros para el usuario y electrodoméstico especificados.');
    }
  } catch (e) {
    throw Exception(
        'Error al obtener la información de la hoja de vida en la base de datos');
  }
}

void updateHJAppliance(HojaVidaElectrodomestico hve) {
  // Obtén una referencia al documento del producto en Firestore
  DocumentReference applianceRef = FirebaseFirestore.instance
      .collection('hojaVidaElectrodomestico')
      .doc(hve.id);

  // Actualiza los campos del producto en Firestore
  applianceRef.update({
    'condicionAmbiental': hve.condicionAmbiental,
    'fechaCompra': hve.fechaCompra,
    'fechaInstalacion': hve.fechaInstalacion,
    'fechaMManual': hve.fechaMManual,
    'fechaUltMantenimiento': hve.fechaUltMantenimiento,
    'tiempoUso': hve.tiempoUso,
    'frecuenciaUso': hve.tiempoUso,
    'ubicacion': hve.ubicacion,
  }).then((_) {
    print('Electrodomestico actualizado correctamente');
  }).catchError((error) {
    print('Error al actualizar el electrodomestico: $error');
  });
}

void deleteHojaVida(HojaVidaElectrodomestico hojaVida) {
  DocumentReference hojaVidaRef = FirebaseFirestore.instance
      .collection('hojaVidaElectrodomestico')
      .doc(hojaVida.id);

  hojaVidaRef.delete().then((doc) {
    print("Electrodomesticos eliminado correctamente");
  }).catchError((error) {
    print('Error al eliminar el electrodomestico: $error');
  });
}

void registerHojaVida(
    BuildContext context,
    String condicionAmbiental,
    String fechaCompra,
    String fechaInstalacion,
    String fechaMManual,
    String fechaUltMant,
    String tiempoUso,
    String frecuenciaUso,
    String ubicacion,
    String applianceId) async {
  try {
    if (condicionAmbiental.isEmpty ||
        fechaCompra.isEmpty ||
        fechaInstalacion.isEmpty ||
        fechaMManual.isEmpty ||
        fechaUltMant.isEmpty ||
        tiempoUso.isEmpty ||
        frecuenciaUso.isEmpty ||
        ubicacion.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, llene todos los campos',
          AlertMessageType.warning);
      return;
    } else {
      String idUser = FirebaseAuth.instance.currentUser!.uid;

      HojaVidaElectrodomestico hje = HojaVidaElectrodomestico(
          id: applianceId,
          condicionAmbiental: condicionAmbiental,
          fechaCompra: DateTime.parse(fechaCompra),
          fechaInstalacion: DateTime.parse(fechaInstalacion),
          fechaMManual: DateTime.parse(fechaMManual),
          fechaUltMantenimiento: DateTime.parse(fechaUltMant),
          tiempoUso: int.parse(tiempoUso),
          frecuenciaUso: frecuenciaUso,
          ubicacion: ubicacion,
          user: idUser);

      await FirebaseFirestore.instance
          .collection('hojaVidaElectrodomestico')
          .doc(applianceId)
          .set(hje.toJson());
      Navigator.pop(context);
    }
  } catch (e) {
    showPersonalizedAlert(context, 'Error al registrar el electrodomestico',
        AlertMessageType.error);
  }
}

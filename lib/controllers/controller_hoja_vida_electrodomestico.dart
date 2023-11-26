// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

Future<HojaVidaElectrodomestico> getHojaVidaExpertoDetails(
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

      print(doc.id);
      return HojaVidaElectrodomestico(
        id: doc.id,
        condicionAmbiental: doc['condicionAmbiental'],
        fechaCompra: DateTime.parse(doc['fechaCompra']),
        fechaInstalacion: DateTime.parse(doc['fechaInstalacion']),
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
        'Error al obtener la información de la hoja de vida en la base de datos $e');
  }
}

void updateHJAppliance(HojaVidaElectrodomestico hve) {
  // Obtén una referencia al documento del producto en Firestore
  DocumentReference applianceRef = FirebaseFirestore.instance
      .collection('hojaVidaElectrodomestico')
      .doc(hve.id);

  // Convierte los objetos DateTime a Strings en el formato deseado
  String fechaCompraString =
      DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(hve.fechaCompra);
  String fechaInstalacionString =
      DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(hve.fechaInstalacion);
  String fechaUltMantString =
      DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(hve.fechaUltMantenimiento);

  // Actualiza los campos del producto en Firestore
  applianceRef.update({
    'condicionAmbiental': hve.condicionAmbiental,
    'fechaCompra': fechaCompraString,
    'fechaInstalacion': fechaInstalacionString,
    'fechaUltMantenimiento': fechaUltMantString,
    'tiempoUso': hve.tiempoUso,
    'frecuenciaUso': hve
        .frecuenciaUso, // Nota: ¿Es esto intencional? ¿Debería ser 'hve.frecuenciaUso'?
    'ubicacion': hve.ubicacion,
  }).then((_) {
    print('Electrodomestico actualizado correctamente');
  }).catchError((error) {
    print('Error al actualizar la hoja de vida electrodomestico: $error');
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
    String fechaUltMant,
    String tiempoUso,
    String frecuenciaUso,
    String ubicacion,
    String applianceId) async {
  try {
    if (condicionAmbiental.isEmpty ||
        fechaCompra.isEmpty ||
        fechaInstalacion.isEmpty ||
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

Future<List<HojaVidaElectrodomestico>> getHVDetails(String uid) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Realiza la consulta a Firebase Firestore
    QuerySnapshot snapshot = await firestore
        .collection('hojaVidaElectrodomestico')
        .where('user', isEqualTo: uid)
        .get();

    // Inicializa una lista para almacenar los electrodomésticos
    List<HojaVidaElectrodomestico> hojaVida = [];
    // Recorre los documentos y crea instancias de la clase Appliance
    for (var doc in snapshot.docs) {
      hojaVida.add(HojaVidaElectrodomestico(
        id: doc.id,
        condicionAmbiental: doc['condicionAmbiental'],
        fechaCompra: DateTime.parse(doc['fechaCompra']),
        fechaInstalacion: DateTime.parse(doc['fechaInstalacion']),
        fechaUltMantenimiento: DateTime.parse(doc['fechaUltMantenimiento']),
        tiempoUso: doc['tiempoUso'],
        frecuenciaUso: doc['frecuenciaUso'],
        ubicacion: doc['ubicacion'],
        user: doc['user'],
      ));
    }
    // Devuelve la lista de electrodomésticos
    return hojaVida;
  } catch (e) {
    // Maneja errores de forma adecuada
    print(
        'Error, no se logro obtener la información de los electrodomésticos: $e');
    throw Exception(
        'No se pudo obtener la información de los electrodomésticos.');
  }
}

String calcularPrioridadMantenimiento(int antiguedad,
    String fechaUltimoMantenimiento, String frecuenciaUso, int tiempoUso) {
      DateTime fechaUltMant = DateTime.parse(fechaUltimoMantenimiento);
  final tiempoDesdeUltimoMantenimiento =
      DateTime.now().difference(fechaUltMant).inDays / 365;

  if (antiguedad > 2.5 ||
      tiempoDesdeUltimoMantenimiento > 1.5 ||
      (['Diario', '5 días a la semana', '3 días a la semana']
              .contains(frecuenciaUso) &&
          tiempoUso > 12)) {
    return 'Alta';
  } else if ((antiguedad > 1.5 && antiguedad <= 2.5) ||
      (tiempoDesdeUltimoMantenimiento > 0.75 &&
          tiempoDesdeUltimoMantenimiento <= 1.5) ||
      (tiempoUso > 8 && tiempoUso <= 12)) {
    return 'Moderada';
  } else {
    return 'Baja';
  }
}

//Calcula la antiguedad
int calcularAntiguedadEnAnios(String fechaCompraStr, String fechaInstalacionStr) {
  // Parsear las fechas desde las cadenas
  DateTime fechaCompra = DateTime.parse(fechaCompraStr);
  DateTime fechaInstalacion = DateTime.parse(fechaInstalacionStr);

  // Calcular la antigüedad en años
  return fechaCompra.difference(fechaInstalacion).inDays ~/ 365;
}
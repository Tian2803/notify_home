// Ignorar advertencias específicas para el archivo
// ignore_for_file: use_build_context_synchronously, avoid_print

// Importación de paquetes y archivos necesarios
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Paquete para formatear fechas
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';

// Función asincrónica para obtener los detalles de la hoja de vida de un electrodoméstico
Future<HojaVidaElectrodomestico> getHojaVidaElectrodomesticoDetalle(
    String idUser, String idAppliance) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    // Consulta a Firestore para obtener la hoja de vida del electrodoméstico específico
    QuerySnapshot snapshot = await firestore
        .collection('hojaVidaElectrodomestico')
        .where('user', isEqualTo: idUser)
        .where('id', isEqualTo: idAppliance)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc =
          snapshot.docs.first; // Obtén el primer documento del QuerySnapshot

      // Crea y retorna un objeto HojaVidaElectrodomestico a partir de los datos del documento
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

// Función asincrónica para obtener detalles de la hoja de vida del electrodoméstico para experto
Future<HojaVidaElectrodomestico> getHojaVidaElectrodomesticoExpertoDetalle(
    String idUser, String idAppliance) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    // Consulta a Firestore para obtener la hoja de vida del electrodoméstico específico para experto
    QuerySnapshot snapshot = await firestore
        .collection('hojaVidaElectrodomestico')
        .where('user', isEqualTo: idUser)
        .where('id', isEqualTo: idAppliance)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc =
          snapshot.docs.first; // Obtén el primer documento del QuerySnapshot

      print(doc.id);

      // Crea y retorna un objeto HojaVidaElectrodomestico a partir de los datos del documento
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

// Función para actualizar la información de la hoja de vida del electrodoméstico
void actualizarHJElectrodomestico(HojaVidaElectrodomestico hve) {
  // Obtén una referencia al documento del electrodoméstico en Firestore
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

  // Actualiza los campos del electrodoméstico en Firestore
  applianceRef.update({
    'condicionAmbiental': hve.condicionAmbiental,
    'fechaCompra': fechaCompraString,
    'fechaInstalacion': fechaInstalacionString,
    'fechaUltMantenimiento': fechaUltMantString,
    'tiempoUso': hve.tiempoUso,
    'frecuenciaUso': hve.frecuenciaUso,
    'ubicacion': hve.ubicacion,
  }).then((_) {
    print('Electrodomestico actualizado correctamente');
  }).catchError((error) {
    print('Error al actualizar la hoja de vida electrodomestico: $error');
  });
}

// Función para eliminar la hoja de vida del electrodoméstico
void eliminarHojaVidaElectrodomestico(HojaVidaElectrodomestico hojaVida) {
  DocumentReference hojaVidaRef = FirebaseFirestore.instance
      .collection('hojaVidaElectrodomestico')
      .doc(hojaVida.id);

  hojaVidaRef.delete().then((doc) {
    print("Electrodomesticos eliminado correctamente");
  }).catchError((error) {
    print('Error al eliminar el electrodomestico: $error');
  });
}

// Función para registrar una nueva hoja de vida del electrodoméstico
void registrarHojaVida(
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
    // Validar que no haya campos vacíos
    if (condicionAmbiental.isEmpty ||
        fechaCompra.isEmpty ||
        fechaInstalacion.isEmpty ||
        fechaUltMant.isEmpty ||
        tiempoUso.isEmpty ||
        frecuenciaUso.isEmpty ||
        ubicacion.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, llene todos los campos',
          AlertMessageType.warning);
    } else {
      String idUser = FirebaseAuth.instance.currentUser!.uid;

      // Crear un objeto HojaVidaElectrodomestico con los datos proporcionados
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

      // Guardar la nueva hoja de vida del electrodoméstico en Firestore
      await FirebaseFirestore.instance
          .collection('hojaVidaElectrodomestico')
          .doc(applianceId)
          .set(hje.toJson());

      // Cerrar la pantalla actual
      Navigator.pop(context);
    }
  } catch (e) {
    // Mostrar una alerta en caso de error
    showPersonalizedAlert(context, 'Error al registrar el electrodomestico',
        AlertMessageType.error);
  }
}

// Función para calcular la prioridad de mantenimiento del electrodoméstico
String calcularPrioridadMantenimiento(int antiguedad,
    String fechaUltimoMantenimiento, String frecuenciaUso, int tiempoUso) {
  DateTime fechaUltMant = DateTime.parse(fechaUltimoMantenimiento);

  // Calcular el tiempo transcurrido desde el último mantenimiento en años
  final tiempoDesdeUltimoMantenimiento =
      DateTime.now().difference(fechaUltMant).inDays / 365;

  // Lógica para determinar la prioridad de mantenimiento basada en diferentes condiciones
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

// Función para calcular la antigüedad en años a partir de las fechas de compra e instalación
int calcularAntiguedadEnAnios(
    String fechaCompraStr, String fechaInstalacionStr) {
  // Parsear las fechas desde las cadenas
  DateTime fechaCompra = DateTime.parse(fechaCompraStr);
  DateTime fechaInstalacion = DateTime.parse(fechaInstalacionStr);

  // Calcular la antigüedad en años
  return fechaCompra.difference(fechaInstalacion).inDays ~/ 365;
}

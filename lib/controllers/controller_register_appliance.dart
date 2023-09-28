// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, use_key_in_widget_constructors
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/models/appliance.dart';
import 'package:notify_home/views/appliance_register_view.dart';
import 'package:notify_home/controllers/alert_dialog.dart';

class ApplianceRegisterController extends StatefulWidget {
  @override
  _ApplianceRegisterControllerState createState() =>
      _ApplianceRegisterControllerState();
}

class _ApplianceRegisterControllerState
    extends State<ApplianceRegisterController> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fabricanteController = TextEditingController();
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController usuarioNameController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController condicionAmbientalController =
      TextEditingController();
  final TextEditingController fechaCompraController = TextEditingController();
  final TextEditingController fechaInstalacionController =
      TextEditingController();
  final TextEditingController fechaManteManualController =
      TextEditingController();
  final TextEditingController fechaUltMantController = TextEditingController();
  final TextEditingController tiempoUsoController = TextEditingController();
  final TextEditingController frecuenciaUsoController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();

  String generateApplianceId() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  void _register() async {
    try {
      String name = nameController.text;
      String fabricante = fabricanteController.text;
      String modelo = modeloController.text;
      String tipo = tipoController.text;
      String condicionAmbiental = condicionAmbientalController.text;
      String fechaCompra = fechaCompraController.text;
      String fechaInstalacion = fechaInstalacionController.text;
      String fechaMManual = fechaManteManualController.text;
      String fechaUltMant = fechaUltMantController.text;
      String tiempoUso = tiempoUsoController.text;
      String frecuenciaUso = frecuenciaUsoController.text;
      String ubicacion = ubicacionController.text;

      if (name.isEmpty ||
          fabricante.isEmpty ||
          modelo.isEmpty ||
          tipo.isEmpty ||
          condicionAmbiental.isEmpty ||
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
      }

      String applianceId = generateApplianceId();
      final uid = FirebaseAuth.instance.currentUser!.uid;

      Appliance appliance = Appliance(
        id: applianceId,
        name: name,
        fabricante: fabricante,
        modelo: modelo,
        tipo: tipo,
        user: uid,
      );

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
        user: uid);

      await FirebaseFirestore.instance
          .collection('electrodomestico')
          .doc(applianceId)
          .set(appliance.toJson())
          .catchError((error) => {
                showPersonalizedAlert(
                    context,
                    'Error al registrar el electrodomestico',
                    AlertMessageType.error)
              });

      await FirebaseFirestore.instance
          .collection('hojaVidaElectrodomestico')
          .doc(applianceId)
          .set(hje.toJson())
          .then((value) => {
                Navigator.pop(context),
              })
          .catchError((error) => {
                showPersonalizedAlert(
                    context,
                    'Error al registrar la hoja vida del electrodomestico',
                    AlertMessageType.error)
              });
    } catch (e) {
      showPersonalizedAlert(context, 'Error al registrar el electrodomestico',
          AlertMessageType.error);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    fabricanteController.dispose();
    modeloController.dispose();
    tipoController.dispose();
    condicionAmbientalController.dispose();
    fechaCompraController.dispose();
    fechaInstalacionController.dispose();
    fechaManteManualController.dispose();
    fechaUltMantController.dispose();
    tiempoUsoController.dispose();
    frecuenciaUsoController.dispose();
    ubicacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ApplianceRegisterView(
      nameController: nameController,
      fabricanteController: fabricanteController,
      modeloController: modeloController,
      tipoController: tipoController,
      condicionAmbController: condicionAmbientalController,
      fechaCompraController: fechaCompraController,
      fechaInstalacionController: fechaInstalacionController,
      fechaManteManualController: fechaManteManualController,
      fechaUltMantController: fechaUltMantController,
      tiempoUsoController: tiempoUsoController,
      frecuenciaUsoController: frecuenciaUsoController,
      ubicacionController: ubicacionController,
      registerPressed: _register,
    );
  }
}

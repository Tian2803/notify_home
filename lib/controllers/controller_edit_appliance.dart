// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/controller_appliance.dart';
import 'package:notify_home/controllers/controller_hoja_vida_electrodomestico.dart';
import 'package:notify_home/models/appliance.dart';
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';
import 'package:notify_home/views/appliance_edit_view.dart';

class ApplianceEditController extends StatefulWidget {
  final Appliance appliance;
  final HojaVidaElectrodomestico hve;
  const ApplianceEditController(
      {super.key, required this.appliance, required this.hve});
  @override
  _ProductEditControllerState createState() => _ProductEditControllerState();
}

class _ProductEditControllerState extends State<ApplianceEditController> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fabricanteController = TextEditingController();
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
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.appliance.name;
    fabricanteController.text = widget.appliance.fabricante;
    modeloController.text = widget.appliance.modelo;
    tipoController.text = widget.appliance.tipo;
    condicionAmbientalController.text = widget.hve.condicionAmbiental;
    fechaCompraController.text =
        DateFormat('yyyy-MM-dd').format(widget.hve.fechaCompra);
    fechaInstalacionController.text =
        DateFormat('yyyy-MM-dd').format(widget.hve.fechaInstalacion);
    fechaManteManualController.text =
        DateFormat('yyyy-MM-dd').format(widget.hve.fechaMManual);
    fechaUltMantController.text =
        DateFormat('yyyy-MM-dd').format(widget.hve.fechaUltMantenimiento);
    tiempoUsoController.text = widget.hve.tiempoUso.toString();
    frecuenciaUsoController.text = widget.hve.frecuenciaUso;
    ubicacionController.text = widget.hve.ubicacion;
  }

  void _update() async {
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

      //En caso de que un campo quede vacio no se actualiza
      name.isEmpty ? name = widget.appliance.name : name = nameController.text;
      fabricante.isEmpty
          ? fabricante = widget.appliance.fabricante.toString()
          : fabricante = fabricanteController.text;
      modelo.isEmpty
          ? modelo = widget.appliance.modelo.toString()
          : modelo = modeloController.text;
      tipo.isEmpty
          ? tipo = widget.appliance.tipo.toString()
          : tipo = tipoController.text;
      condicionAmbiental.isEmpty
          ? condicionAmbiental = widget.hve.condicionAmbiental.toString()
          : condicionAmbiental = condicionAmbientalController.text;
      fechaCompra.isEmpty
          ? fechaCompra = widget.hve.fechaCompra.toString()
          : fechaCompra = fechaCompraController.text;
      fechaInstalacion.isEmpty
          ? fechaInstalacion = widget.hve.fechaInstalacion.toString()
          : fechaInstalacion = fechaInstalacionController.text;
      fechaCompra.isEmpty
          ? fechaMManual = widget.hve.fechaMManual.toString()
          : fechaMManual = fechaManteManualController.text;
      fechaUltMant.isEmpty
          ? fechaUltMant = widget.hve.fechaUltMantenimiento.toString()
          : fechaUltMant = fechaUltMantController.text;
      tiempoUso.isEmpty
          ? tiempoUso = widget.hve.tiempoUso.toString()
          : tiempoUso = tiempoUsoController.text;
      frecuenciaUso.isEmpty
          ? frecuenciaUso = widget.hve.frecuenciaUso.toString()
          : frecuenciaUso = frecuenciaUsoController.text;
      ubicacion.isEmpty
          ? ubicacion = widget.hve.ubicacion.toString()
          : ubicacion = ubicacionController.text;

      Appliance appliance = Appliance(
        id: widget.appliance.id,
        name: name,
        fabricante: fabricante,
        modelo: modelo,
        tipo: tipo,
        user: uid,
      );

      HojaVidaElectrodomestico hvel = HojaVidaElectrodomestico(
          id: widget.hve.id,
          condicionAmbiental: condicionAmbiental,
          fechaCompra: DateTime.parse(fechaCompra),
          fechaInstalacion: DateTime.parse(fechaInstalacion),
          fechaMManual: DateTime.parse(fechaMManual),
          fechaUltMantenimiento: DateTime.parse(fechaUltMant),
          tiempoUso: int.parse(tiempoUso),
          frecuenciaUso: frecuenciaUso,
          ubicacion: ubicacion,
          user: uid);

      Navigator.pop(context);
      updateAppliance(appliance);
      updateHJAppliance(hvel);
      showPersonalizedAlert(context, 'Electrodomestico actualizado correctamente',
          AlertMessageType.success);
    } catch (e) {
      showPersonalizedAlert(context, 'Error al actualizar el electrodomestico',
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
    return ApplianceEditView(
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
      updatePressed: _update,
    );
  }
}

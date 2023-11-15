
// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/controller_hoja_vida_electrodomestico.dart';
import 'package:notify_home/models/electrodomestico.dart';
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';
import 'package:notify_home/views/vista_editar_hoja_vida_electrodomestico.dart';

import 'controller_electrodomestico.dart';

class HVEditController extends StatefulWidget {
  final Electrodomestico appliance;
  final HojaVidaElectrodomestico hve;
  const HVEditController(
      {super.key, required this.appliance, required this.hve});
  @override
  _ProductEditControllerState createState() => _ProductEditControllerState();
}

class _ProductEditControllerState extends State<HVEditController> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fabricanteController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController calificacionEnergeticaController = TextEditingController();
  final TextEditingController condicionAmbientalController =
      TextEditingController();
  final TextEditingController fechaCompraController = TextEditingController();
  final TextEditingController fechaInstalacionController =
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
    calificacionEnergeticaController.text = widget.appliance.calificacionEnergetica;
    condicionAmbientalController.text = widget.hve.condicionAmbiental;
    fechaCompraController.text =
        DateFormat('yyyy-MM-dd').format(widget.hve.fechaCompra);
    fechaInstalacionController.text =
        DateFormat('yyyy-MM-dd').format(widget.hve.fechaInstalacion);
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
      String calificacionEnergetica = calificacionEnergeticaController.text;
      String condicionAmbiental = condicionAmbientalController.text;
      String fechaCompra = fechaCompraController.text;
      String fechaInstalacion = fechaInstalacionController.text;
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
      calificacionEnergetica.isEmpty
          ? calificacionEnergetica = widget.appliance.calificacionEnergetica.toString()
          : calificacionEnergetica = calificacionEnergeticaController.text;
      condicionAmbiental.isEmpty
          ? condicionAmbiental = widget.hve.condicionAmbiental.toString()
          : condicionAmbiental = condicionAmbientalController.text;
      fechaCompra.isEmpty
          ? fechaCompra = widget.hve.fechaCompra.toString()
          : fechaCompra = fechaCompraController.text;
      fechaInstalacion.isEmpty
          ? fechaInstalacion = widget.hve.fechaInstalacion.toString()
          : fechaInstalacion = fechaInstalacionController.text;
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

      Electrodomestico appliance = Electrodomestico(
        id: widget.appliance.id,
        name: name,
        fabricante: fabricante,
        modelo: modelo,
        calificacionEnergetica: calificacionEnergetica,
        expertoId: widget.appliance.expertoId,
        user: uid,
      );

      HojaVidaElectrodomestico hvel = HojaVidaElectrodomestico(
          id: widget.hve.id,
          condicionAmbiental: condicionAmbiental,
          fechaCompra: DateTime.parse(fechaCompra),
          fechaInstalacion: DateTime.parse(fechaInstalacion),
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
    calificacionEnergeticaController.dispose();
    condicionAmbientalController.dispose();
    fechaCompraController.dispose();
    fechaInstalacionController.dispose();
    fechaUltMantController.dispose();
    tiempoUsoController.dispose();
    frecuenciaUsoController.dispose();
    ubicacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HVEditView(
      nameController: nameController,
      fabricanteController: fabricanteController,
      modeloController: modeloController,
      calificacionEnergeticaController: calificacionEnergeticaController,
      condicionAmbController: condicionAmbientalController,
      fechaCompraController: fechaCompraController,
      fechaInstalacionController: fechaInstalacionController,
      fechaUltMantController: fechaUltMantController,
      tiempoUsoController: tiempoUsoController,
      frecuenciaUsoController: frecuenciaUsoController,
      ubicacionController: ubicacionController,
      updatePressed: _update,
    );
  }
}
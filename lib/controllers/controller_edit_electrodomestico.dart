// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/controller_electrodomestico.dart';
import 'package:notify_home/models/electrodomestico.dart';
import 'package:notify_home/views/propietario/vista_editar_electrodomestico.dart';

class ApplianceEditController extends StatefulWidget {
  final Electrodomestico appliance;
  const ApplianceEditController({super.key, required this.appliance});
  @override
  _ProductEditControllerState createState() => _ProductEditControllerState();
}

class _ProductEditControllerState extends State<ApplianceEditController> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fabricanteController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController calificacionEnergeticaController =
      TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.appliance.name;
    fabricanteController.text = widget.appliance.fabricante;
    modeloController.text = widget.appliance.modelo;
    calificacionEnergeticaController.text =
        widget.appliance.calificacionEnergetica;
  }

  void _update() async {
    try {
      String name = nameController.text;
      String fabricante = fabricanteController.text;
      String modelo = modeloController.text;
      String calificacionEnergetica = calificacionEnergeticaController.text;

      //En caso de que un campo quede vacio no se actualiza
      name.isEmpty ? name = widget.appliance.name : name = nameController.text;
      fabricante.isEmpty
          ? fabricante = widget.appliance.fabricante.toString()
          : fabricante = fabricanteController.text;
      modelo.isEmpty
          ? modelo = widget.appliance.modelo.toString()
          : modelo = modeloController.text;
      calificacionEnergetica.isEmpty
          ? calificacionEnergetica =
              widget.appliance.calificacionEnergetica.toString()
          : calificacionEnergetica = calificacionEnergeticaController.text;

      Electrodomestico appliance = Electrodomestico(
        id: widget.appliance.id,
        name: name,
        fabricante: fabricante,
        modelo: modelo,
        calificacionEnergetica: calificacionEnergetica,
        user: uid,
        expertoId: '',
      );

      Navigator.pop(context);
      updateAppliance(appliance);
      showPersonalizedAlert(
          context,
          'Electrodomestico actualizado correctamente',
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ApplianceEditView(
      nameController: nameController,
      fabricanteController: fabricanteController,
      modeloController: modeloController,
      calificacionEnergeticaController: calificacionEnergeticaController,
      updatePressed: _update,
    );
  }
}

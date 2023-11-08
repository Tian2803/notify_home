// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/controller_appliance.dart';
import 'package:notify_home/models/appliance.dart';
import 'package:notify_home/views/editar_appliance_view.dart';

class ApplianceEditController extends StatefulWidget {
  final Appliance appliance;
  //final HojaVidaElectrodomestico hve;
  const ApplianceEditController(
      {super.key, required this.appliance, /*required this.hve*/});
  @override
  _ProductEditControllerState createState() => _ProductEditControllerState();
}

class _ProductEditControllerState extends State<ApplianceEditController> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fabricanteController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.appliance.name;
    fabricanteController.text = widget.appliance.fabricante;
    modeloController.text = widget.appliance.modelo;
    tipoController.text = widget.appliance.tipo;
  }

  void _update() async {
    try {
      String name = nameController.text;
      String fabricante = fabricanteController.text;
      String modelo = modeloController.text;
      String tipo = tipoController.text;

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

      Appliance appliance = Appliance(
        id: widget.appliance.id,
        name: name,
        fabricante: fabricante,
        modelo: modelo,
        tipo: tipo,
        user: uid, 
        expertoId: '',
      );

      Navigator.pop(context);
      updateAppliance(appliance);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ApplianceEditView(
      nameController: nameController,
      fabricanteController: fabricanteController,
      modeloController: modeloController,
      tipoController: tipoController,
      updatePressed: _update,
    );
  }
}

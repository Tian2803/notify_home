// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/controller_appliance.dart';
import 'package:notify_home/models/appliance.dart';
import 'package:notify_home/views/appliance_edit_view.dart';

class ApplianceEditController extends StatefulWidget {
  final Appliance appliance;
  const ApplianceEditController({super.key, required this.appliance});
  @override
  _ProductEditControllerState createState() => _ProductEditControllerState();
}

class _ProductEditControllerState extends State<ApplianceEditController> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController useController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.appliance.name;
    placeController.text = widget.appliance.place;
    descriptionController.text = widget.appliance.description;
    useController.text = widget.appliance.useTime.toString();
    frequencyController.text = widget.appliance.frequency;
  }

  void _update() async {
    try {
      String name = nameController.text;
      String place = placeController.text;
      String description = descriptionController.text;
      String useTime = useController.text;
      String frequency = frequencyController.text;

      //En caso de que un campo quede vacio no se actualiza
      name.isEmpty ? name = widget.appliance.name : name = nameController.text;
      place.isEmpty
          ? place = widget.appliance.place.toString()
          : place = placeController.text;
      description.isEmpty
          ? description = widget.appliance.description
          : description = descriptionController.text;
      useTime.isEmpty
          ? useTime = widget.appliance.useTime.toString()
          : useTime = useController.text;
      frequency.isEmpty
          ? frequency = widget.appliance.frequency.toString()
          : frequency = frequencyController.text;

      Appliance appliance = Appliance(
          id: widget.appliance.id,
          name: name,
          place: place,
          useTime: double.parse(useTime),
          frequency: frequency,
          description: description, 
          user: uid,);

      Navigator.pop(context);
      updateAppliance(appliance);
      showPersonalizedAlert(context, 'Producto actualizado correctamente',AlertMessageType.success);
    } catch (e) {
      showPersonalizedAlert(context, 'Error al actualizar el electrodomestico', AlertMessageType.error);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    placeController.dispose();
    descriptionController.dispose();
    useController.dispose();
    frequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ApplianceEditView(
      nameController: nameController,
      placeController: placeController,
      useController: useController,
      frequencyController: frequencyController,
      descriptionController: descriptionController,
      updatePressed: _update,
    );
  }
}
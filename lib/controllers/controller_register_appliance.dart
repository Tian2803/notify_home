// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, use_key_in_widget_constructors
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
  final TextEditingController placeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController usuarioNameController = TextEditingController();
  final TextEditingController useController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();

  String generateApplianceId() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  void _register() async {
    try {
      String name = nameController.text;
      String place = placeController.text;
      String description = descriptionController.text;
      String use = useController.text;
      String frequency = frequencyController.text;

      if (name.isEmpty ||
          place.isEmpty ||
          description.isEmpty ||
          use.isEmpty ||
          frequency.isEmpty) {
        showPersonalizedAlert(context, 'Por favor, llene todos los campos', AlertMessageType.warning);
        return;
      }

      String applianceId = generateApplianceId();
      final uid = FirebaseAuth.instance.currentUser!.uid;

      Appliance appliance = Appliance(
        id: applianceId,
        name: name,
        place: place,
        useTime: double.parse(use),
        frequency: frequency,
        description: description,
        user: uid,
      );

      await FirebaseFirestore.instance
          .collection('electrodomesticos')
          .doc(applianceId)
          .set(appliance.toJson())
          .then((value) => {
                Navigator.pop(context),
              })
          .catchError((error) => {
                showPersonalizedAlert(context,
                    'Error al registrar el electrodomestico', AlertMessageType.error)
              });
    } catch (e) {
      showPersonalizedAlert(context, 'Error al registrar el electrodomestico', AlertMessageType.error);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    placeController.dispose();
    useController.dispose();
    frequencyController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ApplianceRegisterView(
      nameController: nameController,
      placeController: placeController,
      useController: useController,
      frequencyController:frequencyController,
      descriptionController: descriptionController,
      registerPressed: _register,
    );
  }
}

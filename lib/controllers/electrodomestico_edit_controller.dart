// ignore_for_file: library_private_types_in_public_api

// Importaciones necesarias para el archivo
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify_home/controllers/alert_dialog.dart';
import 'package:notify_home/controllers/electrodomestico_controller.dart';
import 'package:notify_home/models/electrodomestico.dart';
import 'package:notify_home/views/propietario/vista_editar_electrodomestico.dart';

// Clase StatefulWidget para la edición de electrodomésticos
class ApplianceEditController extends StatefulWidget {
  final Electrodomestico electrodomestico;
  // Constructor que toma un electrodoméstico como parámetro
  const ApplianceEditController({super.key, required this.electrodomestico});

  @override
  _ProductEditControllerState createState() => _ProductEditControllerState();
}

class _ProductEditControllerState extends State<ApplianceEditController> {
  // Controladores para los campos de texto
  final TextEditingController nombreElectrodomesticoController =
      TextEditingController();
  final TextEditingController fabricanteController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController calificacionEnergeticaController =
      TextEditingController();
  // Identificador del usuario actual
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // Inicialización de controladores con valores actuales del electrodoméstico
    nombreElectrodomesticoController.text = widget.electrodomestico.name;
    fabricanteController.text = widget.electrodomestico.fabricante;
    modeloController.text = widget.electrodomestico.modelo;
    calificacionEnergeticaController.text =
        widget.electrodomestico.calificacionEnergetica;
  }

  // Función para actualizar los datos del electrodoméstico
  void _update() async {
    try {
      // Obtención de valores de los controladores
      String name = nombreElectrodomesticoController.text;
      String fabricante = fabricanteController.text;
      String modelo = modeloController.text;
      String calificacionEnergetica = calificacionEnergeticaController.text;

      // Verificación de campos vacíos antes de actualizar
      name.isEmpty
          ? name = widget.electrodomestico.name
          : name = nombreElectrodomesticoController.text;
      fabricante.isEmpty
          ? fabricante = widget.electrodomestico.fabricante.toString()
          : fabricante = fabricanteController.text;
      modelo.isEmpty
          ? modelo = widget.electrodomestico.modelo.toString()
          : modelo = modeloController.text;
      calificacionEnergetica.isEmpty
          ? calificacionEnergetica =
              widget.electrodomestico.calificacionEnergetica.toString()
          : calificacionEnergetica = calificacionEnergeticaController.text;

      // Creación de una instancia actualizada de Electrodomestico
      Electrodomestico electrodomestico = Electrodomestico(
        id: widget.electrodomestico.id,
        name: name,
        fabricante: fabricante,
        modelo: modelo,
        calificacionEnergetica: calificacionEnergetica,
        user: uid,
        expertoId: '',
      );

      // Navegación de regreso y llamada a función de actualización
      Navigator.pop(context);
      actualizarElectrodomestico(electrodomestico);
      showPersonalizedAlert(
          context,
          'Electrodomestico actualizado correctamente',
          AlertMessageType.success);
    } catch (e) {
      // Manejo de errores en caso de falla en la actualización
      showPersonalizedAlert(context, 'Error al actualizar el electrodomestico',
          AlertMessageType.error);
    }
  }

  @override
  void dispose() {
    // Liberación de recursos de los controladores al salir del widget
    nombreElectrodomesticoController.dispose();
    fabricanteController.dispose();
    modeloController.dispose();
    calificacionEnergeticaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Devuelve la vista para la edición de electrodomésticos
    return ApplianceEditView(
      nameController: nombreElectrodomesticoController,
      fabricanteController: fabricanteController,
      modeloController: modeloController,
      calificacionEnergeticaController: calificacionEnergeticaController,
      updatePressed: _update,
    );
  }
}

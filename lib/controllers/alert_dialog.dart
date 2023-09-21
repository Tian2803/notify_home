// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

void showPersonalizedAlert(
    BuildContext context, String message, AlertMessageType alertMessageType) {
  final iconData = _getIconData(alertMessageType);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(iconData, color: Colors.white), // Agrega el ícono aquí
          const SizedBox(width: 8), // Espacio entre el ícono y el texto
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: _getSnackBarColor(alertMessageType),
    ),
  );
}


Color _getSnackBarColor(AlertMessageType alertMessageType) {
  switch (alertMessageType) {
    case AlertMessageType.success:
      return Colors.green;
    case AlertMessageType.error:
      return Colors.red;
    case AlertMessageType.warning:
      return Colors.yellow;
    case AlertMessageType.notification:
      return Colors.blue;
    default:
      return Colors.blue; // Color por defecto o cualquier otro valor que desees.
  }
}

enum AlertMessageType {
  success,
  error,
  warning,
  notification
}

IconData _getIconData(AlertMessageType messageType) {
  switch (messageType) {
    case AlertMessageType.success:
      return Icons.check_circle;
    case AlertMessageType.error:
      return Icons.error;
    case AlertMessageType.warning:
      return Icons.warning;
    case AlertMessageType.notification:
      return Icons.info;
    default:
      return Icons.info;
  }
}
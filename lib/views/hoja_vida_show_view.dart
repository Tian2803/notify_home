// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';

class HojaVidaShowView extends StatelessWidget {
  final HojaVidaElectrodomestico hojaVida;

  const HojaVidaShowView({required this.hojaVida});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(
        title: const Text('Detalles de la hoja de vida'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Expanded(
            child: ListView(children: [
              const SizedBox(height: 5.0),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Ubicacion: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: hojaVida.ubicacion,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Condicion ambiental: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: hojaVida.condicionAmbiental,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Fecha de compra: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          DateFormat('dd/MM/yyyy').format(hojaVida.fechaCompra),
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Fecha de instalacion: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: DateFormat('dd/MM/yyyy')
                          .format(hojaVida.fechaInstalacion),
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Fecha de mantenimiento manual: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: DateFormat('dd/MM/yyyy')
                          .format(hojaVida.fechaMManual),
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Fecha de ultimo mantenimiento: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: DateFormat('dd/MM/yyyy')
                          .format(hojaVida.fechaUltMantenimiento),
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Frecuencia de uso: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: hojaVida.frecuenciaUso,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Tiempo de uso: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: hojaVida.tiempoUso.toString(),
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
            ]),
          ),
        ]),
      ),
    );
  }
}

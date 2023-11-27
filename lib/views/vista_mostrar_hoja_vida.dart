// ignore_for_file: use_key_in_widget_constructors

// Importaciones necesarias para el funcionamiento del widget.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify_home/models/hoja_vida_electrodomestico.dart';

// Widget de presentación de detalles de la hoja de vida de un electrodoméstico.
class HojaVidaShowView extends StatelessWidget {
  // Objeto HojaVidaElectrodomestico que contiene la información a mostrar.
  final HojaVidaElectrodomestico hojaVida;

  // Constructor que requiere un objeto HojaVidaElectrodomestico.
  const HojaVidaShowView({required this.hojaVida});

  // Método de construcción del árbol de widgets.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detalles de la hoja de vida'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          // Lista expandida que contiene varios RichText para mostrar detalles.
          Expanded(
            child: ListView(children: [
              const SizedBox(height: 5.0),
              // RichText para mostrar la ubicación del electrodoméstico.
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Ubicacion: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: hojaVida.ubicacion,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // RichText para mostrar la condición ambiental del electrodoméstico.
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Condicion ambiental: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: hojaVida.condicionAmbiental,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // RichText para mostrar la fecha de compra del electrodoméstico.
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Fecha de compra: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text:
                          DateFormat('dd/MM/yyyy').format(hojaVida.fechaCompra),
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // RichText para mostrar la fecha de instalación del electrodoméstico.
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Fecha de instalacion: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: DateFormat('dd/MM/yyyy')
                          .format(hojaVida.fechaInstalacion),
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // RichText para mostrar la fecha del último mantenimiento del electrodoméstico.
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Fecha de ultimo mantenimiento: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: DateFormat('dd/MM/yyyy')
                          .format(hojaVida.fechaUltMantenimiento),
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // RichText para mostrar la frecuencia de uso del electrodoméstico.
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Frecuencia de uso: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: hojaVida.frecuenciaUso,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // RichText para mostrar el tiempo de uso en horas del electrodoméstico.
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Tiempo de uso: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: hojaVida.tiempoUso.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
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

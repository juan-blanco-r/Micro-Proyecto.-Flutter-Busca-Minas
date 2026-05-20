// lib/screens/pantalla_marcadores.dart
import 'package:flutter/material.dart';
import '../models/preferencias.dart';

class PantallaMarcadores extends StatelessWidget {
  const PantallaMarcadores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo Negro Puro
      appBar: AppBar(
        title: const Text('REGISTROS DE RED'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            _buildSeccionDificultad('SECTOR FÁCIL', Preferencias.obtenerPuntajes('facil'), Colors.limeAccent),
            const SizedBox(height: 25),
            _buildSeccionDificultad('SECTOR MEDIO', Preferencias.obtenerPuntajes('medio'), Colors.orangeAccent),
            const SizedBox(height: 25),
            _buildSeccionDificultad('SECTOR DIFÍCIL', Preferencias.obtenerPuntajes('dificil'), Colors.redAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionDificultad(String titulo, List<int> tiempos, Color colorNeon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: colorNeon, width: 1),
        boxShadow: [
          BoxShadow(color: colorNeon.withOpacity(0.2), blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la Dificultad con Brillo
          Text(
            titulo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorNeon,
              letterSpacing: 2,
              shadows: [Shadow(color: colorNeon, blurRadius: 10)],
            ),
          ),
          const Divider(color: Colors.white24, height: 25),
          
          if (tiempos.isEmpty)
            const Text(
              'SIN REGISTROS EN ESTE NÚCLEO',
              style: TextStyle(color: Colors.white38, fontSize: 13, letterSpacing: 1),
            )
          else
            Column(
              children: tiempos.asMap().entries.map((entry) {
                int puesto = entry.key + 1;
                int segundos = entry.value;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NODO #0$puesto',
                        style: const TextStyle(color: Colors.white70, fontSize: 15, letterSpacing: 1),
                      ),
                      Text(
                        '$segundos s',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          shadows: [Shadow(color: colorNeon, blurRadius: 5)],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
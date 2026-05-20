// lib/screens/pantalla_juego.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/modelos.dart';
import '../models/gestor_tablero.dart';
import '../models/preferencias.dart';

class PantallaJuego extends StatefulWidget {
  final Dificultad dificultad;

  const PantallaJuego({Key? key, required this.dificultad}) : super(key: key);

  @override
  State<PantallaJuego> createState() => _PantallaJuegoState();
}

class _PantallaJuegoState extends State<PantallaJuego> {
  late GestorTablero gestor;
  int tiempoTranscurrido = 0;
  Timer? cronometro;

  @override
  void initState() {
    super.initState();
    _iniciarJuego();
  }

  void _iniciarJuego() {
    gestor = GestorTablero(widget.dificultad);
    tiempoTranscurrido = 0;
    cronometro?.cancel();
    setState(() {});
  }

  void _iniciarCronometro() {
    if (cronometro != null && cronometro!.isActive) return;
    cronometro = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (gestor.estado == EstadoJuego.jugando) {
        setState(() { tiempoTranscurrido++; });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    cronometro?.cancel();
    super.dispose();
  }

  void _onCasillaTap(int f, int c) {
    if (gestor.estado != EstadoJuego.jugando || gestor.tablero[f][c].tieneBandera) return;
    setState(() {
      if (!gestor.primerClicRealizado) { _iniciarCronometro(); }
      gestor.revelarCasilla(f, c);
    });
    _revisarFinDePartida();
  }

  void _onCasillaLongPress(int f, int c) {
    if (gestor.estado != EstadoJuego.jugando) return;
    setState(() { gestor.alternarBandera(f, c); });
  }

  void _revisarFinDePartida() async {
    if (gestor.estado != EstadoJuego.jugando) {
      bool esVictoria = gestor.estado == EstadoJuego.victoria;
      
      if (esVictoria) {
        await Preferencias.guardarPuntaje(widget.dificultad.name, tiempoTranscurrido);
      }
      
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final Color colorDialogo = esVictoria ? Colors.limeAccent : Colors.redAccent;
          return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: colorDialogo, width: 2),
            ),
            title: Text(
              esVictoria ? "SISTEMA DEPURADO" : "FALLO CRÍTICO",
              textAlign: TextAlign.center,
              style: TextStyle(color: colorDialogo, fontWeight: FontWeight.bold, letterSpacing: 2, shadows: [Shadow(color: colorDialogo, blurRadius: 10)]),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Tiempo ciclo: $tiempoTranscurrido s", style: const TextStyle(color: Colors.white)),
                if (esVictoria) 
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text("REGISTRO GUARDADO", style: TextStyle(color: Colors.limeAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () { Navigator.pop(context); Navigator.pop(context); },
                child: const Text("SALIR", style: TextStyle(color: Colors.white70)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: colorDialogo, foregroundColor: Colors.black),
                onPressed: () { Navigator.pop(context); _iniciarJuego(); },
                child: Text(esVictoria ? "REPETIR" : "REINTENTAR", style: const TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          );
        }
      );
    }
  }

  // Paleta de Colores Neón para Números
  Color _obtenerColorNeonNumero(int minas) {
    switch (minas) {
      case 1: return Colors.cyanAccent; // Cian
      case 2: return Colors.limeAccent; // Lima
      case 3: return Colors.purpleAccent; // Magenta
      case 4: return Colors.yellowAccent; // Amarillo
      case 5: return Colors.orangeAccent; // Naranja
      case 6: return const Color.fromARGB(255, 241, 60, 211); // Púrpura
      default: return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color neonPanel = Colors.cyanAccent;

    return Scaffold(
      backgroundColor: Colors.black, // FONDO NEGRO PURO
      appBar: AppBar(title: const Text('RED MINADA')),
      body: Column(
        children: [
          // Panel Superior Neón
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: neonPanel, width: 1),
              boxShadow: [BoxShadow(color: neonPanel, blurRadius: 10, spreadRadius: -2)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(Icons.blur_on, '${gestor.totalMinas}', Colors.redAccent),
                _buildInfoItem(Icons.timer_outlined, '$tiempoTranscurrido', Colors.white),
              ],
            ),
          ),
          
          // Tablero de Juego
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black, // Aseguramos negro detrás de la cuadrícula
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double boardSize = constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight;
                    boardSize -= 20;

                    return SizedBox(
                      width: boardSize,
                      height: boardSize,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gestor.columnas,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemCount: gestor.filas * gestor.columnas,
                        itemBuilder: (context, index) {
                          int f = index ~/ gestor.columnas;
                          int c = index % gestor.columnas;
                          Casilla casilla = gestor.tablero[f][c];

                          return GestureDetector(
                            onTap: () => _onCasillaTap(f, c),
                            onLongPress: () => _onCasillaLongPress(f, c),
                            onSecondaryTap: () => _onCasillaLongPress(f, c),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: casilla.estaRevelada ? Colors.grey.shade900 : Colors.black, // Negro si no está revelada
                                borderRadius: BorderRadius.circular(3),
                                // Borde neón sutil para casillas no reveladas
                                border: Border.all(
                                  color: casilla.estaRevelada ? Colors.grey.shade800 : neonPanel.withOpacity(0.5),
                                  width: 1,
                                ),
                                boxShadow: casilla.estaRevelada ? [] : [
                                  BoxShadow(color: neonPanel.withOpacity(0.2), blurRadius: 2),
                                ],
                              ),
                              child: Center(child: _construirContenidoCasillaNeon(casilla)),
                            ),
                          );
                        },
                      ),
                    );
                  }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String valor, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 10),
        Text(
          valor,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color, shadows: [Shadow(color: color, blurRadius: 10)]),
        ),
      ],
    );
  }

  Widget _construirContenidoCasillaNeon(Casilla casilla) {
    if (!casilla.estaRevelada) {
      return casilla.tieneBandera 
        ? const Icon(
            Icons.flag_rounded, // <- CORREGIDO: Ícono de bandera real
            color: Colors.cyanAccent, 
            size: 20, 
            shadows: [
              Shadow(color: Colors.cyanAccent, blurRadius: 10), // <- CORREGIDO: Usamos Shadow puro
            ],
          ) 
        : const SizedBox();
    }
    
    if (casilla.tieneMina) {
      return const Icon(
        Icons.dangerous_rounded, 
        color: Colors.redAccent, 
        size: 24, 
        shadows: [
          Shadow(color: Colors.redAccent, blurRadius: 15), // <- CORREGIDO: Usamos Shadow puro
        ],
      );
    }

    if (casilla.minasAdyacentes > 0) {
      final Color colorNum = _obtenerColorNeonNumero(casilla.minasAdyacentes);
      return Text(
        '${casilla.minasAdyacentes}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.white,
          shadows: [
            Shadow(color: colorNum, blurRadius: 10),
            Shadow(color: colorNum, blurRadius: 5),
          ],
        ),
      );
    }
    
    return const SizedBox();
  }
}
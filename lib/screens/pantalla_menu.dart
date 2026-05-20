// lib/screens/pantalla_menu.dart
import 'package:flutter/material.dart';
import '../models/modelos.dart';
import 'pantalla_juego.dart';
import 'pantalla_marcadores.dart';

class PantallaMenuPrincipal extends StatelessWidget {
  const PantallaMenuPrincipal({Key? key}) : super(key: key);

  void _seleccionarDificultad(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      isScrollControlled: true, // Permite que el modal se adapte mejor al contenido
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: Colors.cyanAccent, width: 1), 
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView( // Agregamos un scroll para evitar el Overflow
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SELECCIONA NIVEL',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                      letterSpacing: 2,
                      shadows: [Shadow(color: Colors.cyanAccent, blurRadius: 10)],
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildDificultadItem(context, 'Fácil', '6x6 - 10 Minas', Colors.limeAccent, Dificultad.facil),
                  _buildDificultadItem(context, 'Medio', '8x8 - 20 Minas', Colors.orangeAccent, Dificultad.medio),
                  _buildDificultadItem(context, 'Difícil', '10x10 - 30 Minas', Colors.redAccent, Dificultad.dificil),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDificultadItem(BuildContext context, String titulo, String desc, Color color, Dificultad dif) {
    return ListTile(
      leading: Icon(Icons.stop_circle_outlined, color: color),
      title: Text(titulo, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      subtitle: Text(desc, style: const TextStyle(color: Colors.white70)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => PantallaJuego(dificultad: dif)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título del Menú
                const Text(
                  'NÚCLEO CENTRAL',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                    shadows: [
                      Shadow(color: Colors.cyanAccent, blurRadius: 15),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                // Botones Neón Individuales (Solo los útiles)
                BotonMenuNeon(
                  texto: 'INICIAR JUEGO',
                  icono: Icons.play_arrow_rounded,
                  colorNeon: Colors.limeAccent,
                  onTap: () => _seleccionarDificultad(context),
                ),
                BotonMenuNeon(
                  texto: 'REGISTROS',
                  icono: Icons.emoji_events_outlined,
                  colorNeon: Colors.purpleAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PantallaMarcadores()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget personalizado: Botón con Borde y Brillo Neón
class BotonMenuNeon extends StatefulWidget {
  final String texto;
  final IconData icono;
  final Color colorNeon;
  final VoidCallback onTap;

  const BotonMenuNeon({
    Key? key,
    required this.texto,
    required this.icono,
    required this.colorNeon,
    required this.onTap,
  }) : super(key: key);

  @override
  State<BotonMenuNeon> createState() => _BotonMenuNeonState();
}

class _BotonMenuNeonState extends State<BotonMenuNeon> {
  double _scale = 1.0;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final double blur = _isHovering ? 25 : 15;

    return GestureDetector(
      onTapDown: (_) => setState(() { _scale = 0.95; _isHovering = true; }),
      onTapUp: (_) {
        setState(() { _scale = 1.0; _isHovering = false; });
        widget.onTap();
      },
      onTapCancel: () => setState(() { _scale = 1.0; _isHovering = false; }),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 280,
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.black, 
            borderRadius: BorderRadius.circular(5), 
            border: Border.all(color: widget.colorNeon, width: 2), 
            boxShadow: [
              BoxShadow(color: widget.colorNeon, blurRadius: blur, spreadRadius: -2),
              BoxShadow(color: widget.colorNeon.withOpacity(0.5), blurRadius: 5, spreadRadius: 1),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.texto,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [Shadow(color: widget.colorNeon, blurRadius: 5)],
                ),
              ),
              Icon(widget.icono, color: widget.colorNeon, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}
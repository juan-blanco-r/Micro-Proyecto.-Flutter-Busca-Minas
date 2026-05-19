// lib/screens/pantalla_splash.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'pantalla_menu.dart';

class PantallaSplash extends StatefulWidget {
  const PantallaSplash({Key? key}) : super(key: key);

  @override
  State<PantallaSplash> createState() => _PantallaSplashState();
}

class _PantallaSplashState extends State<PantallaSplash> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), _navegarAlMenu);
  }

  void _navegarAlMenu() {
    if (!mounted) return;
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const PantallaMenuPrincipal()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color neonColor = Colors.cyanAccent; // Cambiado a final para evitar conflictos de constantes

    return Scaffold(
      backgroundColor: Colors.black, // Fondo Negro Puro
      body: Stack(
        children: [
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícono con Brillo (CORREGIDO: Propiedad cambiada a boxShadow)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: neonColor.withOpacity(0.5), 
                          blurRadius: 40, 
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(Icons.hub, size: 100, color: neonColor),
                  ),
                  const SizedBox(height: 30),
                  
                  // Título con doble brillo neón (CORREGIDO: Se removió el 'const' problemático)
                  Text(
                    'BUSCAMINAS\nNEON',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(color: neonColor, blurRadius: 20),
                        Shadow(color: neonColor, blurRadius: 10),
                        const Shadow(color: Colors.white, blurRadius: 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: TextButton(
                onPressed: _navegarAlMenu,
                child: Text(
                  'SALTAR >',
                  style: TextStyle(
                    color: neonColor,
                    fontSize: 16,
                    letterSpacing: 2,
                    shadows: [Shadow(color: neonColor, blurRadius: 10)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
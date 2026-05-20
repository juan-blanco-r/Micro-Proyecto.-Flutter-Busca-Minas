// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para controlar la barra de estado
import 'screens/pantalla_splash.dart';
import 'models/preferencias.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferencias.inicializar();
  
  // Forzamos la barra de estado superior a ser transparente/negra
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const BuscaminasApp());
}

class BuscaminasApp extends StatelessWidget {
  const BuscaminasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Definimos el estilo Neón principal (Cian)
    const Color neonPrincipal = Colors.cyanAccent;

    return MaterialApp(
      title: 'Buscaminas Neon',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // Forzamos modo oscuro para el diseño neón
      
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Fondo Negro Puro
        primaryColor: neonPrincipal,
        
        // Estilo de la AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: neonPrincipal,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            // Brillo neón en el título de la AppBar
            shadows: [
              Shadow(color: neonPrincipal, blurRadius: 15),
              Shadow(color: neonPrincipal, blurRadius: 10),
            ],
          ),
          iconTheme: IconThemeData(color: neonPrincipal),
        ),
        
        // Estilo de los textos por defecto
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const PantallaSplash(),
    );
  }
}
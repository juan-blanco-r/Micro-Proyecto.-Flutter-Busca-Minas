// lib/models/preferencias.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Preferencias {
  static SharedPreferences? _prefs;

  // Inicializa el almacenamiento en el navegador/sistema
  static Future<void> inicializar() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Guarda un nuevo tiempo y mantiene ordenados los mejores 5 (menor tiempo es mejor)
  static Future<void> guardarPuntaje(String dificultad, int tiempo) async {
    List<int> puntajes = obtenerPuntajes(dificultad);
    puntajes.add(tiempo);
    
    // Ordenamos de menor a mayor tiempo
    puntajes.sort();

    // Guardamos solo los mejores 5 registros
    if (puntajes.length > 5) {
      puntajes = puntajes.sublist(0, 5);
    }
    
    // Convertimos la lista a texto plano JSON para almacenarla
    await _prefs?.setString('records_$dificultad', jsonEncode(puntajes));
  }

  // Recupera la lista de tiempos guardados para una dificultad específica
  static List<int> obtenerPuntajes(String dificultad) {
    String? jsonStr = _prefs?.getString('records_$dificultad');
    if (jsonStr == null) return [];
    
    try {
      List<dynamic> decodificado = jsonDecode(jsonStr);
      return decodificado.map((e) => e as int).toList();
    } catch (e) {
      return []; // Si hay algún error de lectura, devolvemos lista vacía
    }
  }
}
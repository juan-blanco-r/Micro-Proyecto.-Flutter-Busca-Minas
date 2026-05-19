// lib/models/servicio_marcadores.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'modelos.dart'; // Asegúrate de que aquí esté definido tu enum Dificultad

class RecordMarcador {
  final int tiempo; // En segundos
  final int intentos;
  final String fecha;

  RecordMarcador({
    required this.tiempo,
    required this.intentos,
    required this.fecha,
  });

  // Convierte un registro a un mapa para guardarlo como JSON
  Map<String, dynamic> toJson() => {
        'tiempo': tiempo,
        'intentos': intentos,
        'fecha': fecha,
      };

  // Crea un registro a partir de un mapa JSON
  factory RecordMarcador.fromJson(Map<String, dynamic> json) {
    return RecordMarcador(
      tiempo: json['tiempo'] as int,
      intentos: json['intentos'] as int,
      fecha: json['fecha'] as String,
    );
  }
}

class ServicioMarcadores {
  // Llaves únicas para guardar en las preferencias según la dificultad
  static String _obtenerLlave(Dificultad dificultad) {
    switch (dificultad) {
      case Dificultad.facil:
        return 'high_scores_facil';
      case Dificultad.medio:
        return 'high_scores_medio';
      case Dificultad.dificil:
        return 'high_scores_dificil';
    }
  }

  // Guardar un nuevo récord en la lista correspondiente
  static Future<void> guardarRecord(Dificultad dificultad, int tiempo, int intentos) async {
    final prefs = await SharedPreferences.getInstance();
    final llave = _obtenerLlave(dificultad);
    
    // Generar formato de fecha legible (ej: 17/05/2026)
    final ahora = DateTime.now();
    final fechaStr = "${ahora.day.toString().padLeft(2, '0')}/${ahora.month.toString().padLeft(2, '0')}/${ahora.year}";

    List<RecordMarcador> actuales = await obtenerMarcadores(dificultad);
    
    // Crear el nuevo registro
    actuales.add(RecordMarcador(tiempo: tiempo, intentos: intentos, fecha: fechaStr));

    // Ordenar los récords: primero por menor tiempo, si empatan, por menor número de intentos
    actuales.sort((a, b) {
      int compTiempo = a.tiempo.compareTo(b.tiempo);
      if (compTiempo != 0) return compTiempo;
      return a.intentos.compareTo(b.intentos);
    });

    // Mantener únicamente el Top 5 para cumplir con el formato de tabla limpia
    if (actuales.length > 5) {
      actuales = actuales.sublist(0, 5);
    }

    // Mapear los objetos a texto plano serializado
    List<String> jsonStringList = actuales.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(llave, jsonStringList);
  }

  // Obtener la lista de marcadores de una dificultad específica
  static Future<List<RecordMarcador>> obtenerMarcadores(Dificultad dificultad) async {
    final prefs = await SharedPreferences.getInstance();
    final llave = _obtenerLlave(dificultad);
    final listaRaw = prefs.getStringList(llave);

    if (listaRaw == null) return [];

    return listaRaw.map((item) => RecordMarcador.fromJson(jsonDecode(item) as Map<String, dynamic>)).toList();
  }

  // Borrar por completo el almacenamiento local de marcadores
  static Future<void> borrarTodosLosMarcadores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('high_scores_facil');
    await prefs.remove('high_scores_medio');
    await prefs.remove('high_scores_dificil');
  }
}
// lib/models/modelos.dart

// Define en qué estado se encuentra la partida actual
enum EstadoJuego { 
  jugando, 
  victoria, 
  derrota 
}

// Define las dificultades requeridas en el documento
enum Dificultad { 
  facil,    // 6x6, 10 minas
  medio,    // 8x8, 20 minas
  dificil   // 10x10, 30 minas
}

class Casilla {
  final int fila;
  final int columna;
  bool tieneMina;
  bool estaRevelada;
  int minasAdyacentes;
  bool tieneBandera;

  Casilla({
    required this.fila,
    required this.columna,
    this.tieneMina = false,
    this.estaRevelada = false,
    this.minasAdyacentes = 0,
    this.tieneBandera = false,
  });

  // Método auxiliar para limpiar la casilla cuando el jugador reinicie la partida
  void reiniciar() {
    tieneMina = false;
    estaRevelada = false;
    minasAdyacentes = 0;
    tieneBandera = false;
  }
}
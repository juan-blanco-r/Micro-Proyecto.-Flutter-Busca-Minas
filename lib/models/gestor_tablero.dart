// lib/models/gestor_tablero.dart
import 'dart:math';
import 'modelos.dart'; // Importamos la clase Casilla y los enums que creamos antes

class GestorTablero {
  List<List<Casilla>> tablero = [];
  int filas = 0;
  int columnas = 0;
  int totalMinas = 0;
  
  EstadoJuego estado = EstadoJuego.jugando;
  bool primerClicRealizado = false;
  int casillasReveladasSeguras = 0;

  // El constructor recibe la dificultad y configura el tamaño automáticamente 
  GestorTablero(Dificultad dificultad) {
    _configurarDificultad(dificultad);
    inicializarTablero();
  }

  void _configurarDificultad(Dificultad dificultad) {
    switch (dificultad) {
      case Dificultad.facil:
        filas = 6; columnas = 6; totalMinas = 10; // 
        break;
      case Dificultad.medio:
        filas = 8; columnas = 8; totalMinas = 20; // 
        break;
      case Dificultad.dificil:
        filas = 10; columnas = 10; totalMinas = 30; // 
        break;
    }
  }

  // 1. Crea una matriz llena de casillas vacías
  void inicializarTablero() {
    tablero = List.generate(
      filas,
      (f) => List.generate(columnas, (c) => Casilla(fila: f, columna: c)),
    );
    estado = EstadoJuego.jugando;
    primerClicRealizado = false;
    casillasReveladasSeguras = 0;
  }

  // 2. Coloca las minas ALEATORIAMENTE, respetando la regla del primer clic 
  void _generarMinas(int filaPrimerClic, int colPrimerClic) {
    int minasColocadas = 0;
    Random random = Random();

    while (minasColocadas < totalMinas) {
      int f = random.nextInt(filas);
      int c = random.nextInt(columnas);

      // Verificamos que no haya una mina ya ahí y que NO sea la casilla del primer clic 
      if (!tablero[f][c].tieneMina && !(f == filaPrimerClic && c == colPrimerClic)) {
        tablero[f][c].tieneMina = true;
        minasColocadas++;
      }
    }
    _calcularNumerosAdyacentes();
  }

  // 3. Calcula cuántas minas hay alrededor de cada casilla
  void _calcularNumerosAdyacentes() {
    for (int f = 0; f < filas; f++) {
      for (int c = 0; c < columnas; c++) {
        if (tablero[f][c].tieneMina) continue;

        int minas = 0;
        // Revisamos los 8 vecinos alrededor
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            if (i == 0 && j == 0) continue; // No revisarse a sí mismo
            int nf = f + i;
            int nc = c + j;
            if (nf >= 0 && nf < filas && nc >= 0 && nc < columnas) {
              if (tablero[nf][nc].tieneMina) minas++;
            }
          }
        }
        tablero[f][c].minasAdyacentes = minas;
      }
    }
  }

  // 4. Lógica de interacción cuando el jugador toca una casilla 
  void revelarCasilla(int f, int c) {
    if (estado != EstadoJuego.jugando || tablero[f][c].estaRevelada || tablero[f][c].tieneBandera) return;

    // Si es el primer clic de la partida, generamos las minas ahora 
    if (!primerClicRealizado) {
      _generarMinas(f, c);
      primerClicRealizado = true;
    }

    Casilla casilla = tablero[f][c];
    casilla.estaRevelada = true;

    if (casilla.tieneMina) {
      estado = EstadoJuego.derrota; // ¡Boom! 
      _revelarTodasLasMinas();
    } else {
      casillasReveladasSeguras++;
      
      // Si la casilla está vacía (0 minas), revelamos las adyacentes (Flood Fill) 
      if (casilla.minasAdyacentes == 0) {
        _floodFill(f, c);
      }

      _verificarVictoria();
    }
  }

  // Algoritmo recursivo para revelar casillas vacías conectadas 
  void _floodFill(int f, int c) {
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int nf = f + i;
        int nc = c + j;

        if (nf >= 0 && nf < filas && nc >= 0 && nc < columnas) {
          Casilla vecina = tablero[nf][nc];
          if (!vecina.estaRevelada && !vecina.tieneMina && !vecina.tieneBandera) {
            vecina.estaRevelada = true;
            casillasReveladasSeguras++;
            // Si la vecina también es 0, llamamos a la función de nuevo (recursividad)
            if (vecina.minasAdyacentes == 0) {
              _floodFill(nf, nc);
            }
          }
        }
      }
    }
  }

  // Colocar o quitar banderas
  void alternarBandera(int f, int c) {
    if (estado != EstadoJuego.jugando || tablero[f][c].estaRevelada) return;
    tablero[f][c].tieneBandera = !tablero[f][c].tieneBandera;
  }

  void _verificarVictoria() {
    int totalCasillasSeguras = (filas * columnas) - totalMinas;
    if (casillasReveladasSeguras == totalCasillasSeguras) {
      estado = EstadoJuego.victoria; 
    }
  }

  void _revelarTodasLasMinas() {
    for (var fila in tablero) {
      for (var casilla in fila) {
        if (casilla.tieneMina) casilla.estaRevelada = true; 
      }
    }
  }
}
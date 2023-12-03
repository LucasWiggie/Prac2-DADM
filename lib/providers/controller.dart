import 'package:flutter/cupertino.dart';
import 'package:prac2_dadm_grupo_d/constants/answer_stages.dart';
import 'package:prac2_dadm_grupo_d/data/keys_map.dart';
import 'package:prac2_dadm_grupo_d/utils/calculate_chart_stats.dart';

import '../models/tile_model.dart';
import '../stats_calculator.dart';

class Controller extends ChangeNotifier {
  bool checkLine = false, isBackOrEnter = false, gameWon = false, gameCompleted = false,
  notEnoughLetters = false;
  String correctWord = ""; // palabra solución
  int currentTile = 0; // lleva la cuenta de en qué casilla de la fila está el jugador
  int currentRow = 0; // lleva la cuenta de en qué fila está el jugador
  List<TileModel> tilesEntered = []; // almacena las letras introducidas por el jugador

  setCorrectWord({required String word}) => correctWord = word; // establecemos la palabra solución

  setKeyTapped({required String value}){ // gestión de la introducción de palabras por teclado por parte del usuario
    // *value es la tecla presionada por el usuario
    if(value == 'ENTER'){ // al presionar enter
      if(currentTile == 5 * (currentRow + 1)){ //comprueba si ha introducido 5 letras
        isBackOrEnter = true;
        checkWord(); // comprobamos si la palabra que ha metido el usuario es correcta
      }else{ //si no hay suficientes letras
        notEnoughLetters = true;
      }
    } else if (value == 'BACK') { // si se ha pulsado BACK para retroceder letra
      notEnoughLetters = false;
      if(currentTile > 5 * (currentRow + 1) - 5){ // elimina la última letra introducida
        currentTile--;
        tilesEntered.removeLast();
        isBackOrEnter = true;
      }
    } else { // cuando el jugador pulsa e introduce una letra
      notEnoughLetters = false;
      if(currentTile < 5 * (currentRow + 1)){ // comprueba si el usuario puede introducir más letras en la fila actual
        tilesEntered.add(TileModel(letter: value, answerStage: AnswerStage.notAnswered)); // se agrega la letra a la lista
        currentTile++;
        isBackOrEnter = false;
      }
    }

    notifyListeners(); // se notifica a los widgets que estén escuchando al controlador (Consumer, por ejemplo)
  }

  checkWord() { // comprueba la palabra introducida por el usuario y actualiza el estado
    List<String> guessed = [],
        remainingCorrect = [
        ]; // listas con las letras adivinadas/las que faltan
    String guessedWord = "";

    for (int i = currentRow * 5; i < (currentRow * 5) + 5; i++) {
      guessed.add(tilesEntered[i]
          .letter); // añadimos las letras introducidas por el usuario en esta fila
    }

    guessedWord =
        guessed.join(); // almacenamos la palabra introducida en guessedWord
    remainingCorrect = correctWord.characters
        .toList(); // guardamos las letras de la palabra correcta

    if (guessedWord == correctWord) { // el usuario ha acertado la palabra
      for (int i = currentRow * 5; i < (currentRow * 5) + 5; i++) {
        tilesEntered[i].answerStage = AnswerStage.correct; // se marca cada letra como correcta en la interfaz, activando AnswerStage.correct
        keysMap.update(tilesEntered[i].letter, (value) => AnswerStage.correct);
        gameWon = true;
        gameCompleted = true; //juego termina si gana
      }
    } else { // si no ha acertado
      // Comprobamos qué letras sí ha acertado en su casilla correcta
      for (int i = 0; i < 5; i++) {
        if (guessedWord[i] == correctWord[i]) {
          remainingCorrect.remove(guessedWord[i]);
          tilesEntered[i + (currentRow * 5)].answerStage = AnswerStage.correct;
          keysMap.update(guessedWord[i], (value) => AnswerStage.correct);
        }
      }

      // Comprobamos qué letras ha acertado que contiene la palabra (pero que no están en la casilla correcta)
      for (int i = 0; i < remainingCorrect.length; i++) {
        for (int j = 0; j < 5; j++) {
          if (remainingCorrect[i] == tilesEntered[j + (currentRow * 5)]
              .letter) { // si es una letra de la palabra solución

            if (tilesEntered[j + (currentRow * 5)].answerStage != AnswerStage
                .correct) { // si no es una letra que ya hemos marcado como correcta
              tilesEntered[j + (currentRow * 5)].answerStage =
                  AnswerStage.contains; // marcamos que está contenida la letra, pero no en esa posición
            }

            final resultKey = keysMap.entries.where((
                element) => // comprueba si esta letra ya se ha marcado previamente como correcta
            element.key == tilesEntered[j + (currentRow * 5)].letter);

            if (resultKey.single.value != AnswerStage
                .correct) { // si todavía no se ha marcado como correcta
              keysMap.update(resultKey.single.key, (value) => AnswerStage
                  .contains); // actualizamos el estado de la tecla del teclado
            }
          }
        }
      }

    // Loop de todas las letras. Si alguna no se ha actualizado como correcta, se indicará como incorrecta
    for (int i = currentRow * 5; i < (currentRow * 5) + 5; i++) {
      if (tilesEntered[i].answerStage == AnswerStage.notAnswered) {
        tilesEntered[i].answerStage = AnswerStage.incorrect;
        final results = keysMap.entries.where((element) =>
        element.key == tilesEntered[i].letter); //cogemos las keys que pueden querer actualizarse
        if (results.single.value == AnswerStage.notAnswered) { //comprobar que answerStage no se ha actualizado ya, si ya es correcta o existe no se puede reescribir
          keysMap.update(
              tilesEntered[i].letter, (value) => AnswerStage.incorrect);
        }
      }
    }
  }
    currentRow++; // pasamos a la siguiente fila
    checkLine = true;
    if(currentRow == 6){
      gameCompleted = true; //juego termina si pierde
    }
    if(gameCompleted){
      statsCalculator(gameWon: gameWon); //calculamos estadisticas
      if(gameWon) {
        setChartStats(actualRow: currentRow); //estadisticas para la gráfica
      }
    }
    notifyListeners();
  }
  }

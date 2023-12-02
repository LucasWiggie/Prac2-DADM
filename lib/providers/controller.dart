import 'package:flutter/cupertino.dart';
import 'package:prac2_dadm_grupo_d/constants/answer_stages.dart';
import 'package:prac2_dadm_grupo_d/data/keys_map.dart';
import 'package:prac2_dadm_grupo_d/utils/calculate_chart_stats.dart';

import '../models/tile_model.dart';
import '../stats_calculator.dart';

class Controller extends ChangeNotifier {
  bool checkLine = false, isBackOrEnter = false, gameWon = false, gameCompleted = false;
  String correctWord = "";
  int currentTile = 0; // lleva la cuenta de en qué casilla de la fila está el jugador
  int currentRow = 0; // lleva la cuenta de en qué fila está el jugador
  List<TileModel> tilesEntered = [];

  setCorrectWord({required String word}) => correctWord = word; // establecemos la palabra solución

  setKeyTapped({required String value}){
    if(value == 'ENTER'){ // al presionar enter
      if(currentTile == 5 * (currentRow + 1)){
        isBackOrEnter = true;
        checkWord(); // comprobamos si la palabra que ha metido el usuario es correcta
      }
    } else if (value == 'BACK') {
      if(currentTile > 5 * (currentRow + 1) - 5){
        currentTile--;
        tilesEntered.removeLast();
        isBackOrEnter = true;
      }
    } else {
      if(currentTile < 5 * (currentRow + 1)){
        tilesEntered.add(TileModel(letter: value, answerStage: AnswerStage.notAnswered));
        currentTile++;
        isBackOrEnter = false;
      }
    }

    notifyListeners();
  }

  checkWord() {
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
        tilesEntered[i].answerStage = AnswerStage.correct;
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

      // Comprobamos qué letras ha acertado que contiene la palabra
      for (int i = 0; i < remainingCorrect.length; i++) {
        for (int j = 0; j < 5; j++) {
          if (remainingCorrect[i] == tilesEntered[j + (currentRow * 5)]
              .letter) { // si es una letra de la palabra solución

            if (tilesEntered[j + (currentRow * 5)].answerStage != AnswerStage
                .correct) { // si no es una letra que ya hemos marcado como correcta
              tilesEntered[j + (currentRow * 5)].answerStage =
                  AnswerStage.contains;
            }

            final resultKey = keysMap.entries.where((
                element) => // comprueba si esta letra ya se ha marcado previamente como correcta
            element.key == tilesEntered[j + (currentRow * 5)].letter);

            if (resultKey.single.value != AnswerStage
                .correct) { // si todavía no se ha marcado como correcta
              keysMap.update(resultKey.single.key, (value) => AnswerStage
                  .contains); // actualizamos
            }
          }
        }
      }


    // Loop de todas las letras. Si alguna no se ha actualizado como correcta, se indicará como incorrecta
    for (int i = currentRow * 5; i < (currentRow * 5) + 5; i++) {
      if (tilesEntered[i].answerStage == AnswerStage.notAnswered) {
        tilesEntered[i].answerStage = AnswerStage.incorrect;
        keysMap.update(
            tilesEntered[i].letter, (value) => AnswerStage.incorrect);
      }
    }
  }
    currentRow++;
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

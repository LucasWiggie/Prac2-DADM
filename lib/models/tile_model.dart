import '../constants/answer_stages.dart';

// Representación de cada casilla
class TileModel {
  final String letter;
  AnswerStage answerStage;

  TileModel({required this.letter, required this.answerStage}); // constructor de la clase
}
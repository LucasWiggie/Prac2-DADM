import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/constants/answer_stages.dart';
import 'package:prac2_dadm_grupo_d/constants/colors.dart';
import 'package:provider/provider.dart';

import '../controller.dart';

class Tile extends StatefulWidget {
  const Tile({required this.index,
    super.key,
  });

  final int index;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {

  Color _backgroundColor = Colors.transparent;
  Color _borderColor = Colors.transparent; // color del borde del grid
  late AnswerStage _answerStage;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _borderColor = Theme.of(context).primaryColorLight;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Cada vez que se introduzca una letra, el Consumer reconstruirá el widget
    // entero y enseñará el texto en la casilla del grid
    return Consumer<Controller> (
        builder: (_, notifier, __){
          String text = "";
          Color fontColor = Colors.white;
          if(widget.index < notifier.tilesEntered.length){
            text = notifier.tilesEntered[widget.index].letter;
            _answerStage = notifier.tilesEntered[widget.index].answerStage; // utilizando notifier, guardamos el tipo de respuesta

            if(_answerStage == AnswerStage.correct){ // si la respuesta es correcta
              _borderColor = Colors.transparent;
              _backgroundColor = correctGreen;
            } else if (_answerStage == AnswerStage.contains){ // si la respuesta está contenida en la palabra
              _borderColor = Colors.transparent;
              _backgroundColor = containsYellow;
            } else if(_answerStage == AnswerStage.incorrect){ // si la respuesta es una letra incorrecta
              _borderColor = Colors.transparent;
              _backgroundColor = Theme.of(context).primaryColorDark;
            } else {
              fontColor = Theme.of(context).textTheme.bodyText2?.color ?? Colors.white;
            }

            return Container(
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  border: Border.all(
                    color: _borderColor,
                  )
                ),
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(text, style: TextStyle().copyWith(
                        color:fontColor
                      ))
                    )));
          } else { return Container(
            decoration: BoxDecoration(
                color: _backgroundColor,
                border: Border.all(
                  color: _borderColor,
                )
            ),
          );}
    });
  }
}
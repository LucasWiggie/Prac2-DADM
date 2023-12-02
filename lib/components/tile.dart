import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/constants/answer_stages.dart';
import 'package:prac2_dadm_grupo_d/constants/colors.dart';
import 'package:provider/provider.dart';

import 'dart:math';

import '../providers/controller.dart';

class Tile extends StatefulWidget {
  const Tile({required this.index,
    super.key,
  });

  final int index;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  Color _backgroundColor = Colors.transparent;
  Color _borderColor = Colors.transparent; // color del borde del grid
  late AnswerStage _answerStage;
  bool _animate = false;

  @override
  void initState() {

    _animationController = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this
    );

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _borderColor = Theme.of(context).primaryColorLight; //refresh
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    _animationController.dispose();
    super.dispose();
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

            if(notifier.checkLine) {
              final delay  = widget.index - (notifier.currentRow - 1) * 5;
              Future.delayed(Duration(milliseconds:300 * delay),(){
                if(mounted) { //aniamcion no ejecuta si el state object no esta en el widget tree
                  _animationController.forward();
                }
                notifier.checkLine = false;
              });

              if (_answerStage ==
                  AnswerStage.correct) { // si la respuesta es correcta
                _backgroundColor = correctGreen;
              } else if (_answerStage == AnswerStage
                  .contains) { // si la respuesta está contenida en la palabra
                _backgroundColor = containsYellow;
              } else if (_answerStage == AnswerStage
                  .incorrect) { // si la respuesta es una letra incorrecta
                _backgroundColor = Theme
                    .of(context)
                    .primaryColorDark;
              } else {
                fontColor = Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    ?.color ?? Colors.white;
                _backgroundColor = Colors.transparent;
              }
            }

            return AnimatedBuilder(
              animation: _animationController,
              builder:(_,child){
                double flip = 0;
                if(_animationController.value > 0.5){
                  flip = pi;
                }
                return Transform(
                  alignment: Alignment.center,
                    transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.003)
                      ..rotateX(_animationController.value * pi)
                        ..rotateX(flip),
                    child: Container(
                        decoration: BoxDecoration(
                            color: flip > 0 ? _backgroundColor : Colors.transparent,
                            border: Border.all(
                              color: flip > 0  ? Colors.transparent : _borderColor,
                            )
                        ),
                        child: FittedBox(
                            fit: BoxFit.contain,
                            child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: flip > 0 ?
                                Text(text, style: TextStyle().copyWith(
                                    color:fontColor
                                ),) : Text(text)
                            ))),
                );
              },
            );
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
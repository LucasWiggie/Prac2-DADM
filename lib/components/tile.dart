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
  late AnimationController _animationController; //Controlador para las animaciones

  Color _backgroundColor = Colors.transparent;
  Color _borderColor = Colors.transparent; // color del borde del grid
  late AnswerStage _answerStage;
  bool _animate = false; //Variable que tiene el control de la animacion

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _borderColor = Theme.of(context).primaryColorLight;
    });

    _animationController = AnimationController(
        duration: Duration(milliseconds: 500), //Duracion de la animacion
        vsync: this
    );

    super.initState();
  }

  @override
  void dispose(){
    _animationController.dispose(); //Para cuando no necesitemos la animacion
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
              final delay  = widget.index - (notifier.currentRow - 1) * 5; //Delay para que giren en efecto domino
              Future.delayed(Duration(milliseconds:300 * delay),(){
                _animationController.forward(); //Lanza la animacion
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
                _backgroundColor = Colors.transparent; //Si esta en modo oscuro al escribir el fondo es transparente
              }
            }

            return AnimatedBuilder( //Para que la animacion funcione se necesita un AnimatedBuilder
              animation: _animationController,
              builder:(_,child){
                double flip = 0;
                if(_animationController.value > 0.5){ //Si la animacion va por la mitad cambia el valor de flip a pi
                  flip = pi;
                }
                return Transform(
                  alignment: Alignment.center,
                    transform: Matrix4.identity() //Matrix4 te ayuda para realizar animaciones avanzadas
                    ..setEntry(3, 2, 0.003) //.. Hace una secuencia de operaciones en el mismo objeto
                      ..rotateX(_animationController.value * pi) //Multiplicas por pi para que gire
                        ..rotateX(flip), //Para que las letras no se vean al reves al girar
                    child: Container(
                        decoration: BoxDecoration(
                            color: flip > 0 ? _backgroundColor : Colors.transparent, //Para que no se coloree inmediatamente, sino cuando está girando
                            border: Border.all(
                              color: flip > 0  ? Colors.transparent : _borderColor, //Para que el borde se ponga transparente cuando esta girando
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
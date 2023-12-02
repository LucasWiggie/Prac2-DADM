import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Bounce extends StatefulWidget {
  const Bounce({required this.child,
    required this.animate,
    Key? key}) : super(key: key);

  final Widget child; //Variables para el bounce
  final bool animate;

  @override
  State<Bounce> createState() => _BounceState();
}


class _BounceState extends State<Bounce> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation <double> _animation;

  @override
  void initState(){
    _animationController = AnimationController ( //Inicializamos el controllador
        duration: Duration(milliseconds: 200), //duracion de la animacion
        vsync: this);

    _animation = TweenSequence<double>(  //Tween ayuda a realizar animaciones complejas
      [
        TweenSequenceItem(tween: Tween(begin: 1.0 ,end: 1.30), weight: 1), //Animacion de agrandarse
        TweenSequenceItem(tween: Tween(begin:1.30 ,end:1.0), weight: 1), //Animacion de ponerse mas pequeño
      ]
    ).animate(CurvedAnimation(parent: _animationController, curve:Curves.bounceInOut)); //Reune las dos animaciones indicadas anteriormente

    super.initState();
  }

  @override
  void dispose(){
    _animationController.dispose(); //para cuando no se utilice la animacion
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Bounce oldWidget){ //Para cuando las animaciones se ejecuten
    if(widget.animate){
      _animationController.reset(); //reiniciamos la animacion a 0
      _animationController.forward(); //Inicia la animacion
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context){
    return ScaleTransition( //Realiza la transicion de las animaciones
        scale: _animation,
        child: widget.child,
    );
  }
}
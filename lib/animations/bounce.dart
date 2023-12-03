import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Bounce extends StatefulWidget { //Se encarga de realizar una animación de efecto rebote
  const Bounce({required this.child,
    required this.animate,
    Key? key}) : super(key: key);

  final Widget child; //Widget que se animara con ese efecto
  final bool animate; //Variable booleana que indica si se hace o no la animacion

  @override
  State<Bounce> createState() => _BounceState();
}


class _BounceState extends State<Bounce> with SingleTickerProviderStateMixin{ //Uso de SingleTickerProviderStateMixin para poder usar controlador de animaciones

  late AnimationController _animationController; //Se encarga de controlar la animacion
  late Animation <double> _animation; //Crea la animacion de aumentar y disminuir

  @override
  void initState(){ //Metodo que inicializa las variables
    _animationController = AnimationController (
        duration: Duration(milliseconds: 200), //Duracion de la animacion
        vsync: this);

    _animation = TweenSequence<double>( //Se define una secuencia de interpolacion
      [
        TweenSequenceItem(tween: Tween(begin: 1.0 ,end: 1.30), weight: 1), //Cambiamos la escala aumentando el tamaño
        TweenSequenceItem(tween: Tween(begin:1.30 ,end:1.0), weight: 1), //Decrecemos el tamaño
      ]
    ).animate(CurvedAnimation(parent: _animationController, curve:Curves.bounceInOut)); //Realizamos la animacion mediante una curva
    super.initState();
  }

  @override
  void dispose(){ //Para cuando no se quiera utilizar la animacion
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Bounce oldWidget){ //Se llama al metodo cuando se actualiza el widget
    if(widget.animate){ //Si animate es true
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) { //se utiliza addPostFrameCallback para esperar hasta despues del frame actual
        if(mounted) { //la animacion solo ejecutara si este state object permanece el widget tree
          _animationController.reset(); //reseteamos primero la animacion
          _animationController.forward(); //lanzamos la animacion
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context){
    return ScaleTransition( //Se encarga de escalar el child con la animacion _animation aplicando el efecto de rebote
        scale: _animation,
        child: widget.child,
    );
  }
}
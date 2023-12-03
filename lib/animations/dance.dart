import 'package:flutter/cupertino.dart';

class Dance extends StatefulWidget { //Clase que se encarga de realizar la animacion de baile al acertar la palabra
  const Dance({
    required this.child,
    required this.animate,
    required this.delay,
    Key? key}) : super(key: key);

  final Widget child; //Widget que se animara con ese efecto
  final bool animate; //Variable booleana que indica si se hace o no la animacion
  final int delay; //Variable que indica el delay de la animacion

  @override
  State<Dance> createState() => _DanceState();
}

class _DanceState extends State<Dance> with SingleTickerProviderStateMixin{ //Uso del SingleTickerProviderStateMixin para poder usar el controlador de animaciones

  late AnimationController _controller; //Se encarga de controlar la animacion
  late Animation<Offset> _animation; //Crea la animacion de baile

  @override
  void initState() { //Metodo que inicializa las variables
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), //Duracion de la animacion de baile
        vsync: this);
    _animation = TweenSequence<Offset>( //TweenSequence que se encarga de realizar la secuencia de interpolacion
      [
        TweenSequenceItem(tween: Tween(begin:const Offset(0,0),end:const Offset(0,-0.8)), weight: 15), //Mediante TweenSequenceItem cambiamos los valores y pesos
        TweenSequenceItem(tween: Tween(begin:const Offset(0,-0.80),end:const Offset(0,0.0)), weight: 10), //de forma que la tile subirá y bajara dos veces
        TweenSequenceItem(tween: Tween(begin:const Offset(0,0),end:const Offset(0,-0.3)), weight: 12), //aunque disminuyendo su desplazamiento y peso al repetirlo la segunda vez
        TweenSequenceItem(tween: Tween(begin:const Offset(0,-0.30),end:const Offset(0,0.0)), weight: 8),

      ]
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine)); //Realizamos la animacion mediante una curva

    super.initState();
  }

  @override
  void dispose() { //Para cuando no se quiera usar la animacion
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Dance oldWidget) { //Se llama al metodo cuando se actualiza el widget
    if(widget.animate){ //Si animate es true
      Future.delayed(Duration(milliseconds:widget.delay),(){ //se utiliza Future.delayed para agregar un retraso antes de ejecutar la animación
        if(mounted) { //aniamción solo ejecuta si el state object esta en el widget tree
          _controller.forward(); //ejecutas la animacion
        }
      });

    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _animation, //se encarga de aplicar el efecto de baile desplazando el child
                           child: widget.child,
    );
  }
}

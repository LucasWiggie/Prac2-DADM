import 'package:flutter/cupertino.dart';

class Dance extends StatefulWidget {
  const Dance({
    required this.child,
    required this.animate,
    required this.delay,
    Key? key}) : super(key: key);

  final Widget child; //Variables para el baile final
  final bool animate;
  final int delay;

  @override
  State<Dance> createState() => _DanceState();
}

class _DanceState extends State<Dance> with SingleTickerProviderStateMixin{

  late AnimationController _controller; //Controlador de las animaciones
  late Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController( //Incializamos el controlador de animaciones
        duration: const Duration(milliseconds: 1000), //tiempo de duracion de las animaciones
        vsync: this);
    _animation = TweenSequence<Offset>( //Animacion que se encarga de hacer que la tile suba y baje dos veces
      [
        TweenSequenceItem(tween: Tween(begin:Offset(0,0),end:Offset(0,-0.8)), weight: 15),
        TweenSequenceItem(tween: Tween(begin:Offset(0,-0.80),end:Offset(0,0.0)), weight: 10),
        TweenSequenceItem(tween: Tween(begin:Offset(0,0),end:Offset(0,-0.3)), weight: 12),
        TweenSequenceItem(tween: Tween(begin:Offset(0,-0.30),end:Offset(0,0.0)), weight: 8),

      ]
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose(); //para cuando no queramos usar las animaciones
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Dance oldWidget) {
    if(widget.animate){
      Future.delayed(Duration(milliseconds:widget.delay),(){ //crea un delay entre cada tile para que el baile sea correcto
        _controller.forward(); //lanza la animacion
      });

    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) { //Para la transicion de las animaciones
    return SlideTransition(position: _animation,
                           child: widget.child,
    );
  }
}


import 'package:flutter/material.dart';
//se llamará para enseñar un pop up que dure un segundo
runQuickBox({required BuildContext context, required String message}){
  WidgetsBinding.instance?.addPostFrameCallback((timeStamp) { //evadir conflicto por rebuild
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        context: context, builder: (context) {
      Future.delayed(Duration(milliseconds: 1000),(){
        Navigator.maybePop(context); //enseñara la ultima escena en la pila
      });
      return AlertDialog(
        title: Text(message, textAlign: TextAlign.center,),

      );
    });
  });
}

import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/components/tile.dart';
import 'package:provider/provider.dart';
import '../animations/bounce.dart';
import '../animations/dance.dart';
import '../providers/controller.dart';

class Grid extends StatelessWidget {
  const Grid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder( // construye la cuadrícula
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(36, 20, 36, 20),
        itemCount: 30,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          crossAxisCount: 5,
        ),
        itemBuilder: (context, index){ // index lleva la cuenta de cuantas letras ha probado el jugador
          // Consumer escucha los cambios en el objeto Controller y reconstruye
          // parte del widget hijo cuando detecta un cambio
          return Consumer<Controller>( //
            builder:(_,notifier,__){
              bool animate = false; // se activa si el índice de la tile actual coincide con la tile en la que el jugador está interactuando y no está retrocediendo
              bool animateDance = false; // se activa si el jugador acierta una palabra
              int danceDelay = 1600;
              if(index == notifier.currentTile - 1 && !notifier.isBackOrEnter){ //Si el indice de la tile corresponde con la de la linea y no estas yendo hacia atras
                animate = true; // activa animate para hacer la animación
              }
              if(notifier.gameWon) { //Si el jugador ha ganado
                for (int i = notifier.tilesEntered.length - 5; i <
                    notifier.tilesEntered.length; i++) { //recorre la linea de tiles
                  if (index == i) { // si ha acertado una letra
                    animateDance = true; //activa la animacion
                    danceDelay += 150 * (i-((notifier.currentRow - 1)*5)); //crea un delay entre las diferentes tiles
                  }
                }
              }

              // Realiza las animaciones:
              return Dance( // Realiza la animación de las letras saltando
                delay:danceDelay,
                animate: animateDance,
                child: Bounce( // Realiza la animacion de ampliar la casilla
                    animate: animate,
                    child: Tile(index: index,)),
              );
            },
          );
        },
    );
  }
}



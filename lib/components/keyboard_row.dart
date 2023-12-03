import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/constants/answer_stages.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../data/keys_map.dart';
import '../providers/controller.dart';

class KeyboardRow extends StatelessWidget {
  const KeyboardRow({required this.min, required this.max,
    super.key,
  });

  final int min, max;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Consumer escucha los cambios en el objeto Controller y reconstruye
    // parte del widget hijo cuando detecta un cambio
    return Consumer<Controller>( //
      builder: (_, notifier, __) {
        int index = 0; // se incrementará cada vez que avanzamos en el loop de .map y devolvemos un texto
        return IgnorePointer( //ignorará los eventos táctiles si el juego ha sido completado
          ignoring: notifier.gameCompleted,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // La función map hace loop sobre la colección de
          // valores y puede devolver una lista de widgets
          children: keysMap.entries.map((e) { // itera sobre las entradas del mapa de teclas
            index++;
            if(index >= min && index <= max){ // determina si está dentro del rango de teclas que queremos mostrar
              // Establecemos los colores de las teclas según su AnswerStage
              Color color = Theme.of(context).primaryColorLight;
              Color keyColor = Colors.white;
              if(e.value == AnswerStage.correct){ // si la tecla es una letra correcta
                color = correctGreen;
              } else if (e.value == AnswerStage.contains){ // si la tecla es una letra correcta pero no en posición
                color = containsYellow;
              } else if(e.value == AnswerStage.incorrect){ // si la tecla es una letra incorrecta
                color = Theme.of(context).primaryColorDark;
              } else { // si no tiene un estado específico, se utiliza el color del tema
                keyColor = Theme.of(context).textTheme.bodyText2?.color ?? Colors.black;
              }
          
              return Padding( // estructura visual del teclado
                padding: EdgeInsets.all(size.width * 0.006),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox( // define las dimensiones de las teclas
                      width: e.key == 'ENTER' || e.key == 'BACK' ? // dimensiones para las teclas de ENTER o BACK son más grandes
                      size.width * 0.13 :
                      size.width * 0.085,
                      height: size.height * 0.090,
                      child: Material(
                        color: color,
                        child: InkWell( // proporciona un efecto táctil al tocar la pantalla
                            onTap: (){ // al detectar un evento táctil, llamamos a setKeyTapped del controlador para manejar la lógica del evento
                              Provider.of<Controller>(context, listen: false)
                                  .setKeyTapped(value:e.key);
                            },
                            child: Center(child:
                            e.key == 'BACK' ? const Icon(Icons.backspace_outlined) :
                            Text(e.key, style:
                                Theme.of(context).textTheme.bodyText2?.copyWith(
                                  color: keyColor,
                                )
                            ))
                        ),
                      )
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
            //print('index os $index of key: ${e.key}'); // testing
          
          }).toList(),
                ),
        );
      },
    );
  }
}
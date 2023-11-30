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
    return Consumer<Controller>(
      builder: (_, notifier, __) {
        int index = 0; // se incrementará cada vez que avanzamos en el loop de .map y devolvemos un texto
        return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // La función map hace loop sobre la colección de
        // valores y puede devolver una lista de widgets
        children: keysMap.entries.map((e) {
          index++;
          if(index >= min && index <= max){
            // Establecemos los colores de las casillas
            Color color = Theme.of(context).primaryColorLight;
            Color keyColor = Colors.white;
            if(e.value == AnswerStage.correct){
              color = correctGreen;
            } else if (e.value == AnswerStage.contains){
              color = containsYellow;
            } else if(e.value == AnswerStage.incorrect){
              color = Theme.of(context).primaryColorDark;
            } else {
              keyColor = Theme.of(context).textTheme.bodyText2?.color ?? Colors.black;
            }

            return Padding(
              padding: EdgeInsets.all(size.width * 0.006),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                    width: e.key == 'ENTER' || e.key == 'BACK' ? // dimensiones para las teclas de ENTER o BACK
                    size.width * 0.13 :
                    size.width * 0.085,
                    height: size.height * 0.090,
                    child: Material(
                      color: color,
                      child: InkWell(
                          onTap: (){
                            Provider.of<Controller>(context, listen: false)
                                .setKeyTapped(value:e.key);
                          }, // InkWell hace un efecto al detectar un tap de la pantalla
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
      );
      },
    );
  }
}
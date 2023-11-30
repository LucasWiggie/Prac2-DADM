import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/components/stats_tile.dart';
import 'package:prac2_dadm_grupo_d/constants/answer_stages.dart';
import 'package:prac2_dadm_grupo_d/data/keys_map.dart';

import '../main.dart';
import '../stats_calculator.dart';

class StatsBox extends StatelessWidget {
  const StatsBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
              alignment: Alignment.centerRight,
              onPressed: () {
                Navigator.maybePop(context); //salir de la pantalla de estadisticas al pulsar "x"
              }, icon: Icon(
              Icons.clear)),
          Expanded(child: Text('ESTADISTICAS', textAlign: TextAlign.center,)),
          //muestra de datos
          Expanded(
            child: FutureBuilder(
              future: getStats(),
              builder: (context, snapshot) { //acceder a los dtos por la snapshot
                List<String> results = ["0","0","0","0","0"];
                if(snapshot.hasData){
                  results = snapshot.data as List<String>; //meter los resultados guardados
                }
                return Row( // fila con los datos del jugador
                  children: [
                    StatsTile(heading: "Partidas", value: int.parse(results[0])),
                    //dato del jugador (numero y nombre)
                    StatsTile(heading: "Porcentaje\nAciertos", value: int.parse(results[2])),
                    StatsTile(heading: "Racha\nactual", value: int.parse(results[3])),
                    StatsTile(heading: "Mejor\nracha", value: int.parse(results[4])),
                  ],
                );
              },
            ), //fila para los datos
          ),
          Expanded(child:
          ElevatedButton( //botón para volver a jugar
              style: ElevatedButton.styleFrom( //cambiar estilo del boton
                primary: Colors.teal,
              ),
              onPressed: (){ //para jugar otra partida
                keysMap.updateAll((key, value) => value = AnswerStage.notAnswered); //resetear los valores de las teclas
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context)=> MyApp()),
                        (route) => false);
              },//mete una nueva ruta y elimina las anteriores
              child: Text("Replay", style: TextStyle(
                fontSize: 40,
              ),))
          )
        ],
      ),
    );
  }
}



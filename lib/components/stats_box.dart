import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/components/stats_chart.dart';
import 'package:prac2_dadm_grupo_d/components/stats_tile.dart';
import 'package:prac2_dadm_grupo_d/constants/answer_stages.dart';
import 'package:prac2_dadm_grupo_d/data/keys_map.dart';
import "package:charts_flutter/flutter.dart" as charts;
import 'package:prac2_dadm_grupo_d/providers/theme_provider.dart';
import 'package:prac2_dadm_grupo_d/utils/chart_series.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/chart_model.dart';
import '../stats_calculator.dart';

class StatsBox extends StatelessWidget {
  const StatsBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding: EdgeInsets.fromLTRB(size.width*0.08, size.height*0.15, size.width*0.08, size.height*0.15),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
              alignment: Alignment.centerRight,
              onPressed: () {
                Navigator.maybePop(context); //salir de la pantalla de estadisticas al pulsar "x"
              }, icon: const Icon(
              Icons.clear)),
          const Expanded(child: Text('ESTADISTICAS', textAlign: TextAlign.center,)),
          //muestra de datos
          Expanded(
            flex: 2,
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
          const Expanded( //crecaion de la gráfica
            flex: 8,
            child: StatsChart(), //stats de la grafica
          ),
          Expanded(
              flex: 2,
              child:
          ElevatedButton( //botón para volver a jugar
              style: ElevatedButton.styleFrom( //cambiar estilo del boton
                primary: Colors.teal,
              ),
              onPressed: (){ //para jugar otra partida
                keysMap.updateAll((key, value) => value = AnswerStage.notAnswered); //resetear los valores de las teclas
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context)=> const MyApp()),
                        (route) => false);
              },//mete una nueva ruta y elimina las anteriores
              child: const Text("Replay", style: TextStyle(
                fontSize: 40,
              ),))
          )
        ],
      ),
    );
  }
}





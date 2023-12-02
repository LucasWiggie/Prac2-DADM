import 'package:flutter/material.dart';
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
              }, icon: Icon(
              Icons.clear)),
          Expanded(child: Text('ESTADISTICAS', textAlign: TextAlign.center,)),
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
          Expanded( //crecaion de la gráfica
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
              child: FutureBuilder(
                  future: getSeries(),
                  builder: (context, snapshot) {
                    final List<charts.Series<ChartModel,String>> series;//lista de series
                    if(snapshot.hasData){//comprobar si future devuelve info
                      series = snapshot.data as List<charts.Series<ChartModel,String>>;
                      return Consumer<ThemeProvider>(
                        builder: (_,notifier, __) {
                          var color;
                          if(notifier.isDark){ //titulo en blanco si modo oscuro
                            color = charts.MaterialPalette.white;
                          }else{ //si no en negro
                            color = charts.MaterialPalette.black;
                          }
                          return charts.BarChart(
                          series,
                          vertical: false,
                          animate: false,
                          domainAxis: charts.OrdinalAxisSpec(
                            renderSpec: charts.SmallTickRendererSpec(
                              lineStyle: charts.LineStyleSpec(
                                color: charts.MaterialPalette.transparent, //quitar linea lateral
                              ),
                              labelStyle: charts.TextStyleSpec(
                                fontSize: 16, //tamaño numeros laterales
                                color: color,
                              )
                            ),
                          ),
                          primaryMeasureAxis: const charts.NumericAxisSpec(
                            renderSpec: charts.GridlineRendererSpec(
                              lineStyle: charts.LineStyleSpec(
                                color: charts.MaterialPalette.transparent, //quitar lineas interiores
                              ),
                              labelStyle: charts.TextStyleSpec(
                                color: charts.MaterialPalette.transparent, //quitar numeración inferior
                              )
                            )
                          ),
                          barRendererDecorator: charts.BarLabelDecorator(
                            labelAnchor: charts.BarLabelAnchor.end, //poner la puntuación de cada barra al final de estas
                            outsideLabelStyleSpec: charts.TextStyleSpec(
                              color:color,
                            )
                          ),
                          behaviors: [
                            charts.ChartTitle("ACIERTOS POR FILA")
                          ],
                        );
                        },
                      );//devolver la barra de grafica con series
                    }else{
                      return SizedBox(); //si no hay datos
                    }

                  }),
            ),
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



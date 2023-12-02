import "package:charts_flutter/flutter.dart" as charts ;
import "package:shared_preferences/shared_preferences.dart";

import "../models/chart_model.dart";

Future<List<charts.Series<ChartModel, String>>> getSeries() async { //lista para rellenar el gráfico

  List<ChartModel> data =[];
  final prefs = await SharedPreferences.getInstance();
  final row = await prefs.getInt("row");
  final stats = await prefs.getStringList("chart"); //coger los datos de las gráficas
  if(stats != null){ //si hay datos, rellenar la lista de chartModel
    for(var e in stats){
      data.add(ChartModel(actualGame: false, score: int.parse(e))); //contiene los datos de cada barra por fila
    }
  }
  if(row != null){
    data[row-1].actualGame = true; //coloreamos la fila en la que se acaba de acertar
  }

  return [ //devolvemos lista de Series para rellenar el gráfico
    charts.Series<ChartModel,String>(
      id:"Stats",
      data: data,
      domainFn: (model,index){//input de la gráfica
        int i = index! +1; //son seis filas = seis barras
        return i.toString();
      },
      measureFn: (model,index)=> model.score, //output (puntuación de la fila)
      colorFn: (model, index){
        if(model.actualGame){//si esta fila es la actual se pinta de verde
          return charts.MaterialPalette.green.shadeDefault;
        }else{ // si no gris
          return charts.MaterialPalette.gray.shadeDefault;
        }
      },
      labelAccessorFn: (model,index)=> model.score.toString(), //poner los datos de cada barra
    ),
  ];
}
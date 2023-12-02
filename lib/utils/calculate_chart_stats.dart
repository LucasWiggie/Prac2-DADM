import 'package:shared_preferences/shared_preferences.dart';

setChartStats({required int actualRow}) async { //calcular las stats del grafico cada vez que se completa el jueugo

  List<int> distribution = [0,0,0,0,0,0];
  List<String> distributionString = [];

  final stats = await getChartStats(); //comprobar si ya hay info guardada

  if(stats != null){ //si ya hay datos guardados los utilizamos para actualizar esos
    distribution = stats;
  }

  for(int i = 0; i < 6; i++){
    if(actualRow-1 == i){
      distribution[i]++; //se aumenta el numero de aciertos en la fila en la que se ha ganado
    }
  }
  for(var e in distribution){ //pasamos la lista a lista de string para poder guardar los datos
    distributionString.add(e.toString());
  }
  //guardar los datos
  final prefs = await SharedPreferences.getInstance(); //instancia de shared
  prefs.setStringList("chart", distributionString); //guardar la info
  prefs.setInt("row", actualRow); //guardar la fila actual


}

Future<List<int>?> getChartStats() async { //devolver las estadisticas si es que ya existen unas guardadas (para actualizarlas)
  final prefs = await SharedPreferences.getInstance();
  final stats = prefs.getStringList("chart"); //coger los datos
  if(stats != null){ //si ya hay guardados los pasamos a int y los devolvemos
    List<int> result = [];
    for(var e in stats){
      result.add(int.parse(e));
    }
    return result;
  }else{
    return null;
  }
}
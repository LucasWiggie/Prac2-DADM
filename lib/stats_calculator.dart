import 'package:shared_preferences/shared_preferences.dart';

statsCalculator({required bool gameWon}) async {
  //estadisticas
  int played = 0, winsPerGame = 0, wins = 0, streak = 0, maxStreak = 0;

  final stats = await getStats(); //leer lista de stats si existe (await porque recibe un future)
  if(stats != null){ //si existen datos, los actualizamos con loq ue había guardado
    played = int.parse(stats[0]);
    wins = int.parse(stats[1]);
    winsPerGame =int.parse(stats[2]);
    streak = int.parse(stats[3]);
    maxStreak = int.parse(stats[4]);
  }

//actualizamos los datos con resultado de la última partida
  played++; //se ha jugado otra partida
  if(gameWon){
    wins++; //si se ha ganado
    streak++;
  }else{ //si se pierde
    streak = 0;//racha reiniciada
  }

  if(streak > maxStreak){ //si se rompe el record
    maxStreak = streak;
  }
  winsPerGame = ((wins/played)*100).toInt();

  final prefs = await SharedPreferences.getInstance(); //guardar los datos (al ser asincrono tiene que esperar)
  prefs.setStringList("stats", [played.toString(), wins.toString(), winsPerGame.toString(), streak.toString(),maxStreak.toString()]);
}

Future<List<String>?> getStats() async { //devuelve un futuro al que luego se le pondrá el resultado
  final prefs = await SharedPreferences.getInstance();
  final stats = prefs.getStringList("stats"); //comprobar si existe alguna lista de stats
  if(stats != null){
    return stats; //devolver lista si existe
  }else{
    return null; // si no nulo
  }

}
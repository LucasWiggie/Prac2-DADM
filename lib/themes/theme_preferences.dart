import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences{

  static saveTheme({required bool isDark}) async { //Guarda el modo en el que este incluso cuando cierras el programa se queda guardado
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
  }

  static Future<bool> getTheme() async { //Metodo para conseguir el modo en el que esta
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDark') ?? false;
  }

}
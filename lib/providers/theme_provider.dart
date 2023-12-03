import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{ //Se encarga de indicar el modo en el que se esta
  bool isDark = false; //Variable booleana que indica si el fondo es claro u oscuro

  setTheme({required bool turnOn}){ //Actualiza el modo en el que esta
    isDark = turnOn;
    notifyListeners();
  }
}
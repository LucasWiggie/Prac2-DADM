import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  bool isDark = false;

  setTheme({required bool turnOn}){ //Actualiza el modo en el que esta
    isDark = turnOn;
    notifyListeners();
  }
}
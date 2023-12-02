import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData lightTheme = ThemeData( //Configuración para el modo claro
    primaryColorLight: lightThemeLightShade,
    primaryColorDark: lightThemeDarkShade,
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle( //Variable de las letras
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )
    ),
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    textTheme: const TextTheme().copyWith(
        bodyText2:
        const TextStyle(fontWeight: FontWeight.bold, color: Colors.black) // bodyText2 para cambiar la fuente por defecto
    ),
);

final ThemeData darkTheme = ThemeData( //Configuración para el modo oscuro
  primaryColorLight: darkThemeLightShade,
  primaryColorDark: darkThemeDarkShade,
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle( //Variables de las letras
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      )
  ),
  scaffoldBackgroundColor: Colors.black,
  dividerColor: darkThemeLightShade,
  brightness : Brightness.dark,
  textTheme: const TextTheme().copyWith(
      bodyText2:
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.white) // bodyText2 para cambiar la fuente por defecto
  ),
);

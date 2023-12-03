import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData lightTheme = ThemeData( //Configuración para el modo claro
    primaryColorLight: lightThemeLightShade, //Indicamos cual es el color primario claro
    primaryColorDark: lightThemeDarkShade, //Indicamos cual es el color primario oscuro
    appBarTheme: const AppBarTheme( //Configura el aspecto de la barra de aplicacion
        iconTheme: IconThemeData(
          color: Colors.black, //Cambia el color de los iconos a negro
        ),
        backgroundColor: Colors.white, //Color del fondo en blanco
        titleTextStyle: TextStyle( //Variable de las letras
          color: Colors.black, //Cambia el color de las letras, su tamaño y los pone en negrita
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )
    ),
    scaffoldBackgroundColor: Colors.white, //establece el color de fondo predeterminado de las páginas
    brightness: Brightness.light,
    textTheme: const TextTheme().copyWith(
        bodyText2:
        const TextStyle(fontWeight: FontWeight.bold, color: Colors.black) // bodyText2 para cambiar la fuente por defecto
    ),
);

final ThemeData darkTheme = ThemeData( //Configuración para el modo oscuro
  primaryColorLight: darkThemeLightShade, //Indicamos cual es el color primario claro
  primaryColorDark: darkThemeDarkShade, //Color primario oscuro
  appBarTheme: const AppBarTheme( //Aspecto de la barra de aplicacion
      backgroundColor: Colors.black, //Fondo de color negro
      titleTextStyle: TextStyle( //Cambia las letras a color blanco
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      )
  ),
  scaffoldBackgroundColor: Colors.black, //establece el color de fondo predeterminado de las páginas
  dividerColor: darkThemeLightShade, //configura el color de las líneas divisorias en el modo oscuro
  brightness : Brightness.dark,
  textTheme: const TextTheme().copyWith(
      bodyText2:
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.white) // bodyText2 para cambiar la fuente por defecto
  ),
);

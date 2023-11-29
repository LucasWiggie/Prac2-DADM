import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/constants/colors.dart';
import 'package:provider/provider.dart';

import 'controller.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MultiProvider
    (providers: [
      ChangeNotifierProvider(create: (_) => Controller())
  ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wordle Grupo D',
      theme: ThemeData( // configuración de colores y fuentes en la app
        primaryColorLight: lightThemeLightShade,
        primaryColorDark: lightThemeDarkShade,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme().copyWith(
          bodyText2: TextStyle(fontWeight: FontWeight.bold, color: Colors.black) // bodyText2 para cambiar la fuente por defecto
        ),
      ),
      home: HomePage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/constants/colors.dart';
import 'package:prac2_dadm_grupo_d/providers/controller.dart';
import 'package:prac2_dadm_grupo_d/providers/theme_provider.dart';
import 'package:prac2_dadm_grupo_d/utils/theme_preferences.dart';
import 'package:prac2_dadm_grupo_d/constants/themes.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/settings.dart';

void main() {
  runApp(const MyApp()); // MyApp esta arriba del arbol de widgets, para que al volver a jugar se carge la ruta de MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider // Cuando se tenga la data del modo el juego se ejecutará con esa información
    (providers: [
        ChangeNotifierProvider(create: (_) => Controller()), // proveedor para el controlador
        ChangeNotifierProvider(create : (_) =>ThemeProvider()), // proveedor para el proveedor de temas
    ],
      child: FutureBuilder( // widget that provides management of future builds (async operations)
        initialData: false,
        future: ThemePreferences.getTheme(), // Obtiene el tema almacenado en las preferencias
        builder: (context, snapshot) {
          if(snapshot.hasData){
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp){
              Provider.of<ThemeProvider>(context, listen:false).setTheme(turnOn:
              snapshot.data as bool
              );
            });
          }

          // Después de obtener el tema del futuro, se utiliza Consumer<ThemeProvider> para reconstruir la interfaz de
          // usuario con el tema adecuado (oscuro o claro) según las preferencias almacenadas
          return Consumer<ThemeProvider>(
            builder: (_, notifier, __) =>
                MaterialApp( // El widget principal que define la estructura básica de la aplicación.
                  debugShowCheckedModeBanner: false,
                  title: 'Wordle Grupo D',
                  theme: notifier.isDark ? darkTheme : lightTheme, // Tiene en cuenta si esta en el modo oscuro o claro
                  home: const HomePage(),
                ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/constants/colors.dart';
import 'package:prac2_dadm_grupo_d/providers/controller.dart';
import 'package:prac2_dadm_grupo_d/providers/theme_provider.dart';
import 'package:prac2_dadm_grupo_d/themes/theme_preferences.dart';
import 'package:prac2_dadm_grupo_d/themes/themes.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/settings.dart';

void main() {
  runApp(MultiProvider
    (providers: [
      ChangeNotifierProvider(create: (_) => Controller()),
      ChangeNotifierProvider(create : (_) =>ThemeProvider()),
  ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: false,
      future: ThemePreferences.getTheme(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp){
            Provider.of<ThemeProvider>(context, listen:false).setTheme(turnOn:
            snapshot.data as bool
            );
          });
        }
        return Consumer<ThemeProvider>(
          builder: (_, notifier, __) =>
              MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Wordle Grupo D',
                theme: notifier.isDark ? darkTheme : lightTheme,
                home: const HomePage(),
              ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../themes/theme_preferences.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'), //Pantalla de ajustes
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed:(){
            Navigator.maybePop(context);
          }, icon: Icon(Icons.clear)) //Boton de salir de la pantalla de ajustes
        ],
      ),
      body: Column(
        children: [
          Consumer<ThemeProvider>(
              builder: (_,notifier,__){  //Se encarga de guardar cuando se cambia de modo claro a oscuro y viceversa
                bool _isSwitched = false;
                _isSwitched = notifier.isDark;
                return SwitchListTile(value: _isSwitched, onChanged: (value){
                  _isSwitched = value;
                  ThemePreferences.saveTheme(isDark: _isSwitched);
                  Provider.of<ThemeProvider>(context, listen:false).setTheme(turnOn: _isSwitched);
                });
              },
          )
        ]
      ),
    );
  }
}
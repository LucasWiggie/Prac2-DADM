import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/utils/quick_box.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/theme_provider.dart';
import '../utils/theme_preferences.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed:(){
            Navigator.maybePop(context);
          }, icon: const Icon(Icons.clear))
        ],
      ),
      body: Column(
        children: [
          Consumer<ThemeProvider>(
              builder: (_,notifier,__){
                bool _isSwitched = false;
                _isSwitched = notifier.isDark;
                return SwitchListTile(
                    title: const Text("Modo Oscuro"),
                    value: _isSwitched,
                    onChanged: (value){
                  _isSwitched = value;
                  ThemePreferences.saveTheme(isDark: _isSwitched);
                  Provider.of<ThemeProvider>(context, listen:false).setTheme(turnOn: _isSwitched);
                });
              },
          ),
          ListTile( //para poder reiniciar las estadisticas
            title: const Text("Borrar Datos",
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove("stats"); //leer los datos y borrar las estadisticas
              prefs.remove("chart"); //borrar datos de la grafica
              prefs.remove("row");//borrar fila actual
                  runQuickBox(context: context, message: "Datos borrados");
            }
          )
        ]
      ),
    );
  }
}
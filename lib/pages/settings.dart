import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/utils/quick_box.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/theme_provider.dart';
import '../utils/theme_preferences.dart';

class Settings extends StatelessWidget { //Clase que representa una pantalla de ajustes
  const Settings({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold( //Creamos un Scaffold donde meter los aspectos visuales
      appBar: AppBar(
        title: const Text('Ajustes'), //Introducimos un titulo centrado en la AppBar
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed:(){ //Añadimos un boton para poder salir de la pantalla de ajustes al juego
            Navigator.maybePop(context); //Te desplaza al context
          }, icon: const Icon(Icons.clear))
        ],
      ),
      body: Column( //Creamos una columna que contendrá dos hijos, Consumer y ListTile
        children: [
          Consumer<ThemeProvider>( //Uso de Consumer para escuchar cambios en el ThemeProvider
              builder: (_,notifier,__){ //Se llama a builder cada vez que hay cambios
                bool _isSwitched = false; //Variable que indica en que modo se esta
                _isSwitched = notifier.isDark; //Notifica el modo
                return SwitchListTile( //Uso de SwitchListTile para crear un interruptor
                    title: const Text("Modo Oscuro"),
                    value: _isSwitched, //El valor esta vinculado a la variable _isSwitched
                    onChanged: (value){ //En caso de haber cambio se actualiza el valor de _isSwitched
                  _isSwitched = value;
                  ThemePreferences.saveTheme(isDark: _isSwitched); //Se guarda el modo en el que se esta
                  Provider.of<ThemeProvider>(context, listen:false).setTheme(turnOn: _isSwitched); //Se actualiza el modo
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
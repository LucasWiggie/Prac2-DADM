import 'dart:math';

import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/pages/settings.dart';
import 'package:prac2_dadm_grupo_d/utils/quick_box.dart';
import 'package:provider/provider.dart';

import '../components/grid.dart';
import '../components/keyboard_row.dart';
import '../components/stats_box.dart';
import '../constants/words.dart';
import '../data/keys_map.dart';
import '../providers/controller.dart';

class HomePage extends StatefulWidget { // pantalla principal de la aplicación
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> { // lógica de la pantalla principal

  late String _word;

  @override
  void initState(){ // al iniciar la pantalla principal
    final r = Random().nextInt(words.length); // selecciona una palabra aleatoria del archivo con lista de palabras
    _word = words[r];

    // Pasamos la información de la palabra seleccionada al controlador
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp){
      Provider.of<Controller>(context, listen: false) // se pasa la palabra seleccionada al controlador
          .setCorrectWord(word: _word); // se establece la palabra solución en el controlador
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) { // construye la GUI de la pantalla principal
    return Scaffold( // definimos la estructura básica con Scaffold
      appBar: AppBar( // barra superior de la aplicación
        title: const Text('Wordle'), // título
        centerTitle: true,
        elevation: 0,
        actions: [
          // Consumer escucha los cambios en el objeto Controller y reconstruye
          // parte del widget hijo cuando detecta un cambio
          Consumer<Controller>(
            builder: (_,notifier, __){ // se ejecutará cada vez que el Controller cambie
              if(notifier.notEnoughLetters){ //si faltan letras se saca un mensaje
                runQuickBox(context: context, message: "Faltan letras");
              }
              if (notifier.gameCompleted) { // si se ha completado la partida
                if (notifier.gameWon) {
                  if (notifier.currentRow == 6) { //si gana en el ultimo intento
                    runQuickBox(context: context, message: 'Por los pelos');
                  } else { // si gana antes del último intento
                    runQuickBox(context: context, message: '¡Genial!');
                  }
                } else { //si no se ha ganado
                  runQuickBox(context: context, message: notifier.correctWord); // te muestra con un QuickBox la palabra solución
                }
                Future.delayed( // Corrutina que te enseña la pantalla de estadística tras 4 segundos
                  const Duration(milliseconds: 4000),(){
                    if (mounted){ // solo se ejecuta si pertenece al widget tree
                      showDialog(context: context, builder: (_)=> const StatsBox());
                  }
                 },
                );
              }

              return IconButton(onPressed: () async{ // muestra un icono para las estadísticas
                showDialog(context: context, builder: (_)=> StatsBox());
                },
                icon: Icon(Icons.bar_chart_outlined));
              },
          ),
          IconButton(onPressed: (){ // muestra el botón de ajustes
            Navigator.of(context).push(MaterialPageRoute(builder: (context) //Cambia a la pantalla de ajustes
            => Settings()
            ));
          },
              icon: const Icon(Icons.settings) //Crea el boton de ajustes
          )
        ],
      ),
      body: Column( // cuerpo de la pantalla principal, donde estará la cuadrícula y el teclado
        children: [
          const Divider(
            height: 1,
            thickness: 2,
          ),
          const Expanded(
              flex: 7,
              child: Grid()),
          Expanded(
              flex: 4,
              child: Column(
                children: const [
                  KeyboardRow(min: 1, max: 10),
                  KeyboardRow(min: 11, max: 19),
                  KeyboardRow(min: 20, max: 29),
                ],
              )),
        ]
      )
    );
  }
}




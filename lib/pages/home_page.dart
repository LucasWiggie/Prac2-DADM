import 'dart:math';

import 'package:flutter/material.dart';
import 'package:prac2_dadm_grupo_d/pages/settings.dart';
import 'package:provider/provider.dart';

import '../components/grid.dart';
import '../components/keyboard_row.dart';
import '../components/stats_box.dart';
import '../constants/words.dart';
import '../data/keys_map.dart';
import '../providers/controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late String _word;

  @override
  void initState(){
    final r = Random().nextInt(words.length); // selecciona una palabra aleatoria del archivo con lista de palabras
    _word = words[r];

    // Pasamos la información de la palabra seleccionada al controlador
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp){
      Provider.of<Controller>(context, listen: false)
          .setCorrectWord(word: _word);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            showDialog(context: context, builder: (_)=> StatsBox());
          },
          icon: Icon(Icons.bar_chart_outlined)),
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) //Cambia a la pantalla de ajustes
            => Settings()
            ));
          },
              icon: const Icon(Icons.settings) //Crea el boton de ajustes
          )
        ],
      ),
      body: Column(
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




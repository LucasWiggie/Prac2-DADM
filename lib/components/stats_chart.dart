import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chart_model.dart';
import "package:charts_flutter/flutter.dart" as charts;
import 'package:prac2_dadm_grupo_d/utils/chart_series.dart';
import 'package:prac2_dadm_grupo_d/providers/theme_provider.dart';

class StatsChart extends StatelessWidget {
  const StatsChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      child: FutureBuilder(
          future: getSeries(),
          builder: (context, snapshot) {
            final List<charts.Series<ChartModel,String>> series;//lista de series
            if(snapshot.hasData){//comprobar si future devuelve info
              series = snapshot.data as List<charts.Series<ChartModel,String>>;
              return Consumer<ThemeProvider>(
                builder: (_,notifier, __) {
                  var color;
                  if(notifier.isDark){ //titulo en blanco si modo oscuro
                    color = charts.MaterialPalette.white;
                  }else{ //si no en negro
                    color = charts.MaterialPalette.black;
                  }
                  return charts.BarChart(
                    series,
                    vertical: false,
                    animate: false,
                    domainAxis: charts.OrdinalAxisSpec(
                      renderSpec: charts.SmallTickRendererSpec(
                          lineStyle: const charts.LineStyleSpec(
                            color: charts.MaterialPalette.transparent, //quitar linea lateral
                          ),
                          labelStyle: charts.TextStyleSpec(
                            fontSize: 16, //tamaño numeros laterales
                            color: color,
                          )
                      ),
                    ),
                    primaryMeasureAxis: const charts.NumericAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                            lineStyle: charts.LineStyleSpec(
                              color: charts.MaterialPalette.transparent, //quitar lineas interiores
                            ),
                            labelStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.transparent, //quitar numeración inferior
                            )
                        )
                    ),
                    barRendererDecorator: charts.BarLabelDecorator(
                        labelAnchor: charts.BarLabelAnchor.end, //poner la puntuación de cada barra al final de estas
                        outsideLabelStyleSpec: charts.TextStyleSpec(
                          color:color,
                        )
                    ),
                    behaviors: [
                      charts.ChartTitle("ACIERTOS POR FILA")
                    ],
                  );
                },
              );//devolver la barra de grafica con series
            }else{
              return const SizedBox(); //si no hay datos
            }

          }),
    );
  }
}
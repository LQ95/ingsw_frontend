import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataCreazioneAccount.dart';
import 'package:ingsw_frontend/control/StatisticheControl.dart';
import 'GlobImport.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'entity/OrdinazioneData.dart';

class SchermataStatistiche extends StatefulWidget {
  final ValueNotifier<OrdinazioneData?> selectedDataNotifier = ValueNotifier<OrdinazioneData?>(null);
  @override
  _SchermataStatisticheState createState() => _SchermataStatisticheState();
}

class _SchermataStatisticheState extends State<SchermataStatistiche> {
  List<OrdinazioneData> data = []; // Dichiarazione della variabile data


  Future<Widget> generaGrafico() async {
    StatisticheControl db = StatisticheControl();
    List<OrdinazioneData> data = await db.getGuadagniTotaliFromDB();

    // Crea la serie di dati per il grafico
    charts.Series<OrdinazioneData, DateTime> series =
    charts.Series<OrdinazioneData, DateTime>(
      id: 'Ordinazioni',
      domainFn: (OrdinazioneData data, _) => data.date,
      measureFn: (OrdinazioneData data, _) => data.price,
      data: data,
      // Configura l'etichetta del punto del grafico
      labelAccessorFn: (OrdinazioneData data, _) => '${data.date.day}/${data.date.month}/${data.date.year}\n${data.price.toStringAsFixed(2)}',
    );

    // Crea il grafico a linee
    charts.TimeSeriesChart chart = charts.TimeSeriesChart(
      [series],
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      // Configura l'interazione del grafico per mostrare le etichette dei punti
      behaviors: [
        charts.LinePointHighlighter(
          symbolRenderer: charts.CircleSymbolRenderer(),
          showHorizontalFollowLine:
          charts.LinePointHighlighterFollowLineType.nearest,
          showVerticalFollowLine:
          charts.LinePointHighlighterFollowLineType.nearest,
        ),
        charts.SelectNearest(
          eventTrigger: charts.SelectionTrigger.tapAndDrag,
          selectionModelType: charts.SelectionModelType.info,
        )
      ],
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (model) {
            if (model.hasDatumSelection) {
              final selectedDatum = model.selectedDatum.first;
              widget.selectedDataNotifier.value = selectedDatum.datum;
            } else {
              widget.selectedDataNotifier.value = null;
            }
          },
        ),
      ],
    );

    return SizedBox(
      height: 300, // Imposta l'altezza del grafico
      child: chart,
    );
  }

  @override
  Widget build(BuildContext context) {
    int width = MediaQuery
        .of(context)
        .size
        .width
        .toInt();
    int height = MediaQuery
        .of(context)
        .size
        .height
        .toInt();

    return Scaffold(
      appBar: GlobalAppBar,
      drawer: buildDrawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ...

          FutureBuilder(
            future: generaGrafico(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return GestureDetector(
                  onTap: () {
                    widget.selectedDataNotifier.value = null;
                  },
                  child: snapshot.data!,
                );
              }
            },
          ),

          ValueListenableBuilder<OrdinazioneData?>(
            valueListenable: widget.selectedDataNotifier,
            builder: (context, selectedData, _) {
              if (selectedData == null) {
                return const SizedBox
                    .shrink(); // Nasconde il testo quando nessun punto è stato selezionato
              }
              return Text('Guadagni del giorno: $selectedData');
            },
          ),
        ],
      ),
    );
  }
}
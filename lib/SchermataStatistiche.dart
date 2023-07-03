import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataCreazioneAccount.dart';
import 'package:ingsw_frontend/control/StatisticheControl.dart';
import 'GlobImport.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'entity/OrdinazioneData.dart';

class SchermataStatistiche extends StatefulWidget {
  @override
  _SchermataStatisticheState createState() => _SchermataStatisticheState();
}

class _SchermataStatisticheState extends State<SchermataStatistiche> {
  List<OrdinazioneData> data = []; // Dichiarazione della variabile data

  Future<Widget> generaGrafico() async {
    StatisticheControl db = StatisticheControl();
    Map<DateTime, double> stats = await db.getClosedOrdinazioniFromDB();

    // Somma i valori dei conti di ordinazioni con la stessa data
    Map<DateTime, double> aggregatedStats = {};
    for (var entry in stats.entries) {
      DateTime date = entry.key;
      double price = entry.value;

      if (aggregatedStats.containsKey(date)) {
        aggregatedStats[date] = aggregatedStats[date]! + price;
      } else {
        aggregatedStats[date] = price;
      }
    }

    // Ordina le date in ordine crescente
    List<DateTime> sortedDates = aggregatedStats.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    // Crea una lista ordinata di dati per il grafico e assegna alla variabile data
    data = sortedDates.map((date) {
      return OrdinazioneData(date, aggregatedStats[date]!);
    }).toList();

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
    );

    return SizedBox(
      height: 300, // Imposta l'altezza del grafico
      child: chart,
    );
  }

  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();

    return Scaffold(
      appBar: GlobalAppBar,
      drawer: buildDrawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, top: 9),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66420F),
                  ),
                  child: const Text(
                    "Torna Indietro",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: generaGrafico(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: snapshot.data!),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (OrdinazioneData entry in data)
                            Text(
                              '${entry.date.day}/${entry.date.month}/${entry.date.year}: ${entry.price.toStringAsFixed(2)}',
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

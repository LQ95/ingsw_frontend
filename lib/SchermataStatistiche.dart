import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataCreazioneAccount.dart';
import 'package:ingsw_frontend/control/StatisticheControl.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'GlobImport.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'entity/OrdinazioneData.dart';

// const List<String> listaStatistiche = <String> [
//   "Incasso Complessivo",
//   "Valore Medio Conto",
// ];
// String dropdownValue = listaStatistiche.first;

class SchermataStatistiche extends StatefulWidget {
  final ValueNotifier<OrdinazioneData?> selectedDataNotifier =
  ValueNotifier<OrdinazioneData?>(null);

  @override
  _SchermataStatisticheState createState() => _SchermataStatisticheState();
}

class _SchermataStatisticheState extends State<SchermataStatistiche> {
  List<OrdinazioneData> ordinazioni = [];
  DateTime? dataInizio;
  DateTime? dataFine;

  _SchermataStatisticheState() {
    setDefault().then((ordinazioni) {
      setState(() {
        this.ordinazioni = ordinazioni;
      });
    });
  }


  Future<Widget> generaGrafico(List<OrdinazioneData> data) async {

    charts.Series<OrdinazioneData, DateTime> series =
    charts.Series<OrdinazioneData, DateTime>(
      id: 'Ordinazioni',
      domainFn: (OrdinazioneData data, _) => data.date,
      measureFn: (OrdinazioneData data, _) => data.price,
      data: data,
      labelAccessorFn: (OrdinazioneData data, _) =>
      '${data.date.day}/${data.date.month}/${data.date.year}\n${data.price.toStringAsFixed(2)}',
    );

    charts.TimeSeriesChart chart = charts.TimeSeriesChart(
      [series],
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
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
      height: 300,
      child: chart,
    );
  }


  @override
  Widget build(BuildContext context) {
    //sendPort.send(context);
    return Builder(
      builder: (BuildContext context) {

        return Scaffold(
          appBar: GlobalAppBar,
          drawer: buildDrawer(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, top: 9, right: 18),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66420F),
                  ),
                  child: const Text(
                    "Indietro",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: generaGrafico(ordinazioni),
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
                ),
              ),
              Center(
                child: ValueListenableBuilder<OrdinazioneData?>(
                  valueListenable: widget.selectedDataNotifier,
                  builder: (context, selectedData, _) {
                    if (selectedData == null) {
                      return const SizedBox.shrink();
                    }
                    return Text('$selectedData');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("Data iniziale:"),

                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => selezionaDataInizio(context),
                        ),
                        if (dataInizio != null)
                          Text(dataInizio!.toIso8601String()),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Data finale:  "),

                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => selezionaDataFine(context),
                        ),
                        if (dataFine != null)
                          Text(dataFine!.toIso8601String()),
                      ],
                    ),
                    // DropdownButton<String>(
                    //   value: dropdownValue,
                    //   elevation: 16,
                    //   style: const TextStyle(color: Colors.black),
                    //   underline: Container(
                    //     height: 1,
                    //     color: Colors.black,
                    //   ),
                    //   onChanged: (String? value) {
                    //     setState(() {
                    //       dropdownValue = value!;
                    //     });
                    //   },
                    //   items: listaStatistiche.map<DropdownMenuItem<String>>(
                    //         (String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     },
                    //   ).toList(),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                StatisticheControl db = StatisticheControl();
                                if(dataInizio == null || dataFine == null){
                                  ordinazioni = await db.getStatistiche();
                                } else{
                                  ordinazioni = await db.getStatistiche(dataInizio: dataInizio!, dataFine: dataFine!);
                                  print(ordinazioni);
                                  setState(() {});
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF66420F),
                              ),
                              child: const Text("Conferma", style: TextStyle(color: Colors.white70))
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                ordinazioni = await setDefault();
                                dataFine = null;
                                dataInizio = null;
                                widget.selectedDataNotifier.value = null;
                                // dropdownValue = listaStatistiche.first;
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF66420F),
                              ),
                              child: const Text("Reseta", style: TextStyle(color: Colors.white70))
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> selezionaDataInizio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataInizio ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != dataInizio) {
      setState(() {
        dataInizio = picked;
      });
    }
  }

  Future<void> selezionaDataFine(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataFine ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != dataFine) {
      setState(() {
        dataFine = picked;
      });
    }
  }

  Future<List<OrdinazioneData>> setDefault() async {
    StatisticheControl db = StatisticheControl();
    return StatisticheControl().getStatistiche();
  }

}

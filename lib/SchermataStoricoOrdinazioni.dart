import 'package:flutter/material.dart';
import 'package:ingsw_frontend/control/OrdinazioneControl.dart';
import 'GlobImport.dart';
import 'SchermataSelezionaCategoria.dart';
import 'package:flutter/material.dart';

class SchermataStoricoOrdinazioni extends StatefulWidget {
  final String title = "SchermataStoricoOrdinazioni";
  final int idTavolo;
  final List<dynamic>? listaPiatti;
  final int idOrdinazione;

  SchermataStoricoOrdinazioni({required this.idTavolo, this.listaPiatti, required this.idOrdinazione});

  @override
  SchermataStoricoOrdinazioniState createState() => SchermataStoricoOrdinazioniState();
}


class SchermataStoricoOrdinazioniState extends State<SchermataStoricoOrdinazioni> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print("manda stringa");
    sendPort.send("continua");
    print("costruisce widget");
    showAlertNuoviMess(context);

    generaWidgetPietanze() async {
      OrdinazioneControl db = OrdinazioneControl();
      List<dynamic>? listaPietanze = await db.getAllPietanzeFromOrdinazione(widget.idOrdinazione);

      listaPietanze = listaPietanze?.reversed.toList();
      if (listaPietanze != null) {
        Map<String, int> pietanzeQuantita = {};

        for (var pietanza in listaPietanze) {
          String nomePietanza = pietanza['name'];
          pietanzeQuantita[nomePietanza] = (pietanzeQuantita[nomePietanza] ?? 0) + 1;
        }

        return Wrap(
          direction: Axis.vertical,
          children: List.generate(
            pietanzeQuantita.length,
                (index) {
              String nomePietanza = pietanzeQuantita.keys.elementAt(index);
              int quantita = pietanzeQuantita.values.elementAt(index);
              double costoPietanza = listaPietanze?.firstWhere((pietanza) => pietanza['name'] == nomePietanza)['costo'];
              double costoTotale = costoPietanza * quantita;

              return Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: SizedBox(
                  height: 100,
                  width: width * 0.7,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          spreadRadius: 5,
                          color: Color(0xAA110505),
                          offset: Offset(-8, 8),
                        )
                      ],
                      color: Color(0xFF728514),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              nomePietanza,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                quantita.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                costoTotale.toStringAsFixed(1) + "€",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );

      } else {
        return const Text("");
      }
    }

    return Scaffold(
      appBar: GlobalAppBar,
      drawer: buildDrawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, top: 9, right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Center(
                      child: Text(
                        "Tavolo n° ${widget.idTavolo}",
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Storico delle ordinazioni",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 24,
                        ),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        width: width * 0.7,
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Piatto",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Quantità",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Prezzo Totale",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                     ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Center(
                child: SizedBox(
                  width: width * 0.9,
                  height: height * 0.7,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: generaWidgetPietanze(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else {
                              return snapshot.data!;
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
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
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    // Azione da eseguire quando viene premuto il FAB
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchermataSelezionaCategoria(idTavolo: widget.idTavolo, idOrdinazione: widget.idOrdinazione),
                      ),
                    ).then((value) => setState(() {}));
                  },
                  backgroundColor: const Color(0xFF728514),
                  child: Icon(Icons.add), // Icona del FAB
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

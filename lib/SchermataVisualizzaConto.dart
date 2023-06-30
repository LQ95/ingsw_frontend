import 'package:flutter/material.dart';
import 'GlobImport.dart';
import 'control/OrdinazioneControl.dart';

class SchermataVisualizzaConto extends StatefulWidget{
  final String title = "SchermataVisualizzaConto";
  final String idTavolo;
  final int idOrdinazione;

  const SchermataVisualizzaConto({required this.idTavolo, super.key, required this.idOrdinazione});

  @override
  SchermataVisualizzaContoState createState() => SchermataVisualizzaContoState();
}

class SchermataVisualizzaContoState extends State<SchermataVisualizzaConto> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: SizedBox(
                  height: 100,
                  width: width * 0.7,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          spreadRadius: 5,
                          color: Colors.transparent,
                          offset: Offset(-8, 8),
                        )
                      ],
                      color: Colors.transparent,
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
                                "${costoTotale.toStringAsFixed(1)}€",
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 18, top: 9, right: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Conto tavolo ${widget.idTavolo}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            ),

            Center(
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

            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Center(
                  child: SizedBox(
                    width: width * 0.9,
                    height: height * 0.7,
                    child:  DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
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
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 50,
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
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66420F),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Chiudi",
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "ordinazione",
                            style: TextStyle(color: Colors.white70),
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
    );
  }
}

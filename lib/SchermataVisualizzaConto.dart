import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'GlobImport.dart';
import 'control/OrdinazioneControl.dart';
import 'control/PdfControl.dart';

class SchermataVisualizzaConto extends StatefulWidget{
  final String title = "SchermataVisualizzaConto";
  final String idTavolo;
  final int idOrdinazione;

  const SchermataVisualizzaConto({required this.idTavolo, super.key, required this.idOrdinazione});

  @override
  SchermataVisualizzaContoState createState() => SchermataVisualizzaContoState();
}

class SchermataVisualizzaContoState extends State<SchermataVisualizzaConto> {

  OrdinazioneControl db = OrdinazioneControl();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print("manda stringa");
    sendPort.send("continua");
    print("costruisce widget");
    showAlertNuoviMess(context);


    generaWidgetPietanze() async {

      List<dynamic>? listaPietanze = await db.getAllPietanzeFromOrdinazione(widget.idOrdinazione);

      listaPietanze = listaPietanze?.reversed.toList();
      if (listaPietanze != null) {
        Map<String, int> pietanzeQuantita = {};
        double costoTotale = 0;

        try{
          Map<String, dynamic>? ordinazione = await db.getCurrentOrdinazione(int.parse(widget.idTavolo));
          costoTotale = ordinazione?['conto'];
        }
        catch (e) {
          costoTotale = 0;
        }

        for (var pietanza in listaPietanze) {
          String nomePietanza = pietanza['name'];
          int quantita = (pietanzeQuantita[nomePietanza] ?? 0) + 1;
          pietanzeQuantita[nomePietanza] = quantita;
          double costoPietanza = pietanza['costo'];
          // double costoTotalePietanza = costoPietanza * quantita;
          // costoTotale += costoTotalePietanza;
        }

        List<Widget> generatedWidgets = List.generate(pietanzeQuantita.length, (index) {
          String nomePietanza = pietanzeQuantita.keys.elementAt(index);
          int quantita = pietanzeQuantita.values.elementAt(index);
          double costoPietanza = listaPietanze?.firstWhere((pietanza) => pietanza['name'] == nomePietanza)['costo'];
          double costoTotalePietanza = costoPietanza * quantita;

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
                            "${costoTotalePietanza.toStringAsFixed(1)}€",
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
        });

        double costoTotaleOrdinazione = costoTotale;
        generatedWidgets.add(
          Padding(
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
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Totale",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${costoTotaleOrdinazione.toStringAsFixed(1)}€",
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
          ),
        );

        return Wrap(
          direction: Axis.vertical,
          children: generatedWidgets,
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
                      onPressed: () async {
                        OrdinazioneControl db = OrdinazioneControl();
                        List<dynamic>? listaPietanze = await db.getAllPietanzeFromOrdinazione(widget.idOrdinazione);

                        double costoTotale = 0;

                        listaPietanze = listaPietanze?.reversed.toList();

                        double costo = 0;

                        for (var pietanza in listaPietanze!) {


                          costo = costo + pietanza['costo'];

                        }

                        String? data = DateTime.now().toLocal().toString();

                        showAlertConfermaVuoiSalvare(widget.idTavolo,listaPietanze!,costo, data!);
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

  void showAlertConferma(String idTavolo) {
    QuickAlert.show(context: context,
      type: QuickAlertType.confirm,
      text: "Sei sicuro di voler chiudere quest'ordinazione?\nUna volta chiusa non potrà più essere riaperta",
      title: "Vuoi davvero chiudere quest'ordinazione?",
      confirmBtnText: "Si",
      cancelBtnText: "No",
      onConfirmBtnTap: ()  async {
        OrdinazioneControl db = OrdinazioneControl();
        try {
          await db.closeCurrentOrdinazione(idTavolo);
          Navigator.pop(context);
          showAlertSuccesso("L'ordinazione è stata chiusa correttamente");
        }
        catch (e) {
          showAlertErrore("Qualcosa è andato storto, riprova più tadi...");
        }

      },
      onCancelBtnTap: () => Navigator.pop(context),
    );
  }

  void showAlertConfermaVuoiSalvare(String idTavolo,List<dynamic> pietanze, double conto, String data) {
    QuickAlert.show(context: context,
        type: QuickAlertType.confirm,
        text: "Desideri salvare il conto come pdf prima di chiudere l'ordinazione?",
        title: "Salvataggio in corso",
        confirmBtnText: "Si",
        cancelBtnText: "No",
        onConfirmBtnTap: ()  async {
          //SALVATAGGIO PDF
          PdfControl.createPdfConto(pietanze,idTavolo,conto, data);
          Navigator.pop(context);
          showAlertConferma(idTavolo);

        },
        onCancelBtnTap: () {
          Navigator.pop(context);
          showAlertConferma(idTavolo);
        }
    );
  }

  void showAlertSuccesso(String testo) {
    QuickAlert.show(context: context,
        type: QuickAlertType.success,
        text: testo,
        title: "Successo!",
        onConfirmBtnTap: () {Navigator.pop(context); Navigator.pop(context);}
    );
  }

  void showAlertErrore(String errore) {
    QuickAlert.show(context: context,
        type: QuickAlertType.error,
        text: errore,
        title: "Attenzione!"
    );
  }


}

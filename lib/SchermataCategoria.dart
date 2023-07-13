import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataVisualizzaConto.dart';
import 'package:ingsw_frontend/control/CategoriaControl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'GlobImport.dart';
import 'SchermataAggiungiPietanza.dart';
import 'SchermataStoricoOrdinazioni.dart';
import 'control/PietanzeControl.dart';
import 'entity/Utente.dart';

class SchermataCategoria extends StatefulWidget{
  final String title ="SchermataCategoria";
  final String nomeCategoria;
  final int idCategoria;

  const SchermataCategoria({required this.nomeCategoria, required this.idCategoria, super.key});
  @override
  SchermataCategoriaState createState() => SchermataCategoriaState(idCategoria);

}

class SchermataCategoriaState extends State<SchermataCategoria> {
  final int idCategoria;

  Utente utente = Utente();
  CategoriaControl db = CategoriaControl();

  SchermataCategoriaState(this.idCategoria);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    sendPort.send(Utente().getNome);
    showAlertNuoviMess(context);


    generaWidgetPietanze() async{

      List<dynamic>? listaPietanze = await  db.getPietanzeFromCategoria(widget.idCategoria);

      listaPietanze = listaPietanze?.reversed.toList();
      if (listaPietanze != null) {
        return Wrap(
          direction: Axis.vertical,
          children: List.generate(listaPietanze.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: SizedBox(
                height: 300,
                width: width * 0.7,
                child: Stack(
                  children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7,
                            spreadRadius: 5,
                            color: Color(0xAA110505),
                            offset: Offset(-8, 8),
                          ),
                        ],
                        color: Color(0xFF728514),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: SizedBox(
                                width: width * 0.45,
                                child: Text(
                                  listaPietanze?[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Descrizione: " + listaPietanze?[index]['descrizione'],
                                    style: const TextStyle(color: Colors.black87),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Allergeni: " + listaPietanze?[index]['allergeni'],
                                    style: const TextStyle(color: Colors.black87),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  listaPietanze![index]['costo'].toString() + "€",
                                  style: const TextStyle(color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      right: 12,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if(utente.getRuolo == "AMMINISTRATORE" || utente.getRuolo == "SUPERVISORE") {
                              showAlertConferma(listaPietanze?[index]['id']);
                            } else {
                              showAlertErrore("Non hai i permessi necessari per eseguire quest'operazione");
                            }
                          },
                          icon: const Icon(Icons.delete_outline),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );

      }
      else {
        showAlertErrore("C'è stato un problema di connessione con il server, per favore riprova più tardi...");
      }
    }


    return Scaffold(
      appBar: GlobalAppBar,
      drawer: buildDrawer(context),
      body: Center(
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 9, right: 18),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Indietro", style: TextStyle(
                            color: Colors.white70),),
                      ),
                      Center(
                        child: Text( widget.nomeCategoria,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      ElevatedButton(onPressed: () async
                      {
                        if ((utente.getRuolo == "AMMINISTRATORE" || utente.getRuolo == "SUPERVISORE")) {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) =>
                              SchermataAggiungiPietanza(catId: idCategoria)))
                              .then((value) => setState(() {}));
                        }
                        else {
                          showAlertErrore("Non hai i permessi necessari per compiere quest'azione!");
                        }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Aggiungi", style: TextStyle(
                            color: Colors.white70),),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: SizedBox(
                      width: double.infinity,
                      height: height*0.7,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            FutureBuilder(
                              future: generaWidgetPietanze(),
                              builder: (context, snapshot){
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError){
                                  return Text(snapshot.error.toString());
                                } else {
                                  return snapshot.data!;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          )
      ),
    );
  }

  void showAlertConferma(int idPietanza) {
    QuickAlert.show(context: context,
      type: QuickAlertType.confirm,
      text: "",
      title: "Sei sicuro di voler rimuovere questo elemento dalla categoria?",
      confirmBtnText: "Si",
      cancelBtnText: "No",
      onConfirmBtnTap: () async {
        Navigator.pop(context);
        try {
          await db.deletePietanzaFromDB(widget.idCategoria, idPietanza);
          setState(() {});
          showAlertSuccesso("La pietanza è stata rimossa correttamente");
        } catch (e) {
          showAlertErrore("Non siamo riusciti a rimuovere la pietanza, per favore riprova più tardi...");
        }
      },
      onCancelBtnTap: () => Navigator.pop(context),
    );
  }

  void showAlertErrore(String errore) {
    QuickAlert.show(context: context,
        type: QuickAlertType.error,
        text: errore,
        title: "Attenzione!"
    );
  }

  void showAlertSuccesso(String testo) {
    QuickAlert.show(context: context,
        type: QuickAlertType.success,
        text: testo,
        title: "Successo!",
        onConfirmBtnTap: () {Navigator.pop(context);}
    );
  }


}
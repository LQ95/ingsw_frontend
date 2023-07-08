import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataVisualizzaConto.dart';
import 'package:ingsw_frontend/control/OrdinazioneControl.dart';
import 'package:ingsw_frontend/control/TavoloControl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'GlobImport.dart';
import 'SchermataStoricoOrdinazioni.dart';
import 'entity/Utente.dart';

class PaginaOrdinazioniTavoli extends StatefulWidget{
  final String title="PaginaOrdinazioni";

  const PaginaOrdinazioniTavoli({super.key});
  @override
  PaginaOrdinazioniTavoliState createState() => PaginaOrdinazioniTavoliState();

}

class PaginaOrdinazioniTavoliState extends State<PaginaOrdinazioniTavoli> {


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print("manda stringa");
    sendPort.send(Utente().getNome);
    print("costruisce widget");
    showAlertNuoviMess(context);
    generaWidgetTavoli() async {
      TavoloControl db = TavoloControl();
      List<dynamic>? listaTavoli = await db.getAllTavoliFromDB();
      if (listaTavoli != null) {
        return Align(
          alignment: Alignment.center,
          child: Wrap(
            direction: Axis.horizontal,
            runAlignment: WrapAlignment.center,
            runSpacing: 24,
            spacing: 24,
            children: List.generate(listaTavoli.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Container(
                  decoration:const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        spreadRadius: 5,
                        color: Color(0xAA110505),
                        offset: Offset(-4, 4),
                      )
                    ],
                    color: Color(0xFFC89117),
                    //border: Border.all(width: 0),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {Utente utente = Utente();
                    OrdinazioneControl db = OrdinazioneControl();
                    Map<String, dynamic>? ordinazione = await db.getCurrentOrdinazione(listaTavoli![index]['id']);
                    if(utente.getRuolo == "AMMINISTRATORE" || utente.getRuolo == "SUPERVISORE"){
                      if (ordinazione == null) {
                        showAlert("Non è presente nessun'ordinazione per questo tavolo, per favore riprova dopo che né è stata aperta una!");
                      }
                      else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SchermataVisualizzaConto(idTavolo: listaTavoli![index]['id'].toString(), idOrdinazione: ordinazione['id'])));
                      }
                    } else {
                      if(ordinazione == null){
                        showAlertConferma(listaTavoli![index]['id']);
                      }
                      else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SchermataStoricoOrdinazioni(idTavolo: listaTavoli![index]['id'], idOrdinazione: ordinazione['id'])));
                      }
                    }

                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 7,
                      backgroundColor: const Color(0xFFC89117),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(
                          color: Colors.black.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: SizedBox(
                      height: height * 0.15,
                      width: width * 0.25,
                      child: Center(
                        child: Text(
                          "Tavolo${listaTavoli![index]['id']}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
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
                      ElevatedButton(onPressed: () async{
                        Utente utente = Utente();
                        if(utente.getRuolo == "AMMINISTRATORE" || utente.getRuolo == "SUPERVISORE") {
                          TavoloControl db = TavoloControl();
                          await db.deleteTavoloFromDB();
                          setState(() {});
                        } else {
                          showAlertErrore("Non hai i permessi necessari per eseguire quest'operazione");
                        }

                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Rimuovi Tavolo", style: TextStyle(
                            color: Colors.white70),),
                      ),
                      const Text(
                        'Ordinazioni',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 32,
                        ),
                      ),
                      ElevatedButton(onPressed: () async {
                        Utente utente = Utente();
                        if(utente.getRuolo == "AMMINISTRATORE" || utente.getRuolo == "SUPERVISORE") {
                          TavoloControl db = TavoloControl();
                          await db.addTavoloToDB();
                          setState(() {});
                        } else {
                          showAlertErrore("Non hai i permessi necessari per eseguire quest'operazione");
                        }
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Aggiungi Tavolo", style: TextStyle(
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
                              future: generaWidgetTavoli(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Indietro", style: TextStyle(
                            color: Colors.white70),),
                      ),
                    ),
                  ],
                ),
              ]
          )
      ),
    );
  }

  void showAlertErrore(String errore) {
    QuickAlert.show(context: context,
        type: QuickAlertType.error,
        text: errore,
        title: "Attenzione!"
    );
  }

  void showAlertConferma(int idTavolo) {
    QuickAlert.show(context: context,
      type: QuickAlertType.confirm,
      text: "Vuoi aprire una nuova ordinazione per questo tavolo?",
      title: "Nessun'ordinazione presente",
      confirmBtnText: "Si",
      cancelBtnText: "No",
      onConfirmBtnTap: ()  async {OrdinazioneControl db = OrdinazioneControl();
      try {
        String successo = await db.sendOrdinazioneToDb(idTavolo);
        Map<String, dynamic>? ordinazione = await db.getCurrentOrdinazione(idTavolo);

        if (successo == "SUCCESSO") {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => SchermataStoricoOrdinazioni(idTavolo: idTavolo, idOrdinazione: ordinazione!['id'])));
          showAlertSuccesso("Ordinazione aperta correttamente");
        } else {
          Navigator.pop(context);
          showAlertErrore("C'è stato un problema nell'aprire l'ordinazione, forse è già stata creata una nuova ordinazione per questo tavolo");
        }
      } catch (e) {
        showAlertErrore("Si è verificato un errore: ${e.toString()}");
      }
      },
      onCancelBtnTap: () => Navigator.pop(context),
    );
  }

  void showAlertSuccesso(String errore) {
    QuickAlert.show(context: context,
        type: QuickAlertType.success,
        text: errore,
        title: "Successo!"
    );
  }

  void showAlert(String errore) {
    QuickAlert.show(context: context,
        type: QuickAlertType.info,
        text: errore,
        title: "Aspetta!"
    );
  }

}
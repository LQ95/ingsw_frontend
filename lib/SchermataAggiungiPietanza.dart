//Schermata per aggiungere pietanze alle categorie
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'GlobImport.dart';
import 'control/CategoriaControl.dart';
import 'control/PietanzeControl.dart';
import 'entity/Utente.dart';
class SchermataAggiungiPietanza extends StatefulWidget{
  final String title="SchermataAggiungiPietanza";
  final int catId;
  const SchermataAggiungiPietanza({super.key, required this.catId});
  @override
  SchermataAggiungiPietanzaState createState() => SchermataAggiungiPietanzaState(catId);

}

class SchermataAggiungiPietanzaState extends State<SchermataAggiungiPietanza> {
  final int catId;

  SchermataAggiungiPietanzaState(this.catId);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    sendPort.send(Utente().getNome);

    showAlertNuoviMess(context);


    generaWidgetPietanze() async{

      try {
        PietanzeControl db = PietanzeControl();
        CategoriaControl dbCat = CategoriaControl();
        List<dynamic>? listaPietanze = await db.getAllPietanzeFromDB();
        List<dynamic>? listaGiaPresenti = await dbCat.getPietanzeFromCategoria(
            widget.catId);
        listaPietanze = listaPietanze?.reversed.toList();
        listaPietanze?.removeWhere((pietanzeElement) =>
            isPietanzaPresent(pietanzeElement, listaGiaPresenti)
        );
        if (listaPietanze != null) {
          return Wrap(
            direction: Axis.vertical,
            children: List.generate(listaPietanze.length, (index) =>
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: SizedBox(
                      height: 300,
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
                          //border: Border.all(width: 0),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [

                                  SizedBox(
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
                                  ElevatedButton(
                                    onPressed: () =>
                                        showAlertConferma(
                                            listaPietanze?[index]['id'], catId),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF66420F),
                                    ),
                                    child: const Text(
                                      "Aggiungi", style: TextStyle(
                                        color: Colors.white70),),
                                  )

                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Descrizione: " +
                                      listaPietanze?[index]['descrizione'],
                                    style: const TextStyle(
                                        color: Colors.black87),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Allergeni: " +
                                      listaPietanze?[index]['allergeni'],
                                    style: const TextStyle(
                                        color: Colors.black87),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    listaPietanze![index]['costo'].toString() +
                                        "€", style: const TextStyle(
                                      color: Colors.black87),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,)
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                ),),
          );
        }
        else {
          return const Text("");
        }
      }
      catch (e){
        showAlertErrore("Si è verificato un errore di connessione, per favore riprova più tardi...");
      }
    }



    return  Scaffold(
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
                        ElevatedButton(onPressed: () {
                          Navigator.of(context).pop();
                        },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66420F),
                          ),
                          child: const Text("Indietro", style: TextStyle(
                              color: Colors.white70),),
                        ),
                        const Center(
                          child: Text(
                            'Scegli quale pietanza aggiungere',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Container(
                        width: double.infinity,
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ]
            )
        ),
      );
  }

  void showAlertConferma(int idPietanza,int idCategoria) {
    QuickAlert.show(context: context,
      type: QuickAlertType.confirm,
      text: "",
      title: "Sei sicuro di voler aggiungere questo elemento alla categoria?",
      confirmBtnText: "Si",
      cancelBtnText: "No",
      onConfirmBtnTap: () async {
        CategoriaControl db = CategoriaControl();
        Navigator.pop(context);
        try {
          await db.addPietanzaToDB(idCategoria, idPietanza);
          setState(() {});
          showAlertSuccesso("La pietanza è stata aggiunta correttamente");
        } catch (e) {
          showAlertErrore("Non siamo riusciti ad aggiungere la pietanza, per favore riprova più tardi...");
        }

      },
      onCancelBtnTap: () => Navigator.pop(context),
    );
  }


  void showAlertErrore(String errore) {
    QuickAlert.show(context: context,
        type: QuickAlertType.error,
        text: errore,
        title: "Attenzione"
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

  static bool isPietanzaPresent(pietanzeElement, List? listaGiaPresenti) {
    int id=pietanzeElement['id'];
    int index;
    for(index = 0; index<listaGiaPresenti!.length;index++)
      {
       if(listaGiaPresenti[index]['id'] == id ) {
         return true;
       }
      }
      return false;
  }


  }



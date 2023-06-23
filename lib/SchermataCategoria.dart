import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataVisualizzaConto.dart';
import 'package:ingsw_frontend/control/CategoriaControl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'GlobImport.dart';
import 'SchermataStoricoOrdinazioni.dart';
import 'control/PietanzeControl.dart';
import 'entity/Utente.dart';

class SchermataCategoria extends StatefulWidget{
  final String title ="SchermataCategoria";
  final String nomeCategoria;
  final int idCategoria;

  const SchermataCategoria({required this.nomeCategoria, required this.idCategoria, super.key});
  @override
  SchermataCategoriaState createState() => SchermataCategoriaState();

}

class SchermataCategoriaState extends State<SchermataCategoria> {

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    generaWidgetPietanze() async{

      CategoriaControl db = CategoriaControl();
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
                                Text(
                                  "Descrizione: " + listaPietanze?[index]['descrizione'],
                                  style: const TextStyle(color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Allergeni: " + listaPietanze?[index]['allergeni'],
                                  style: const TextStyle(color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
                            showAlertConferma(listaPietanze?[index]['id']);
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
                      ElevatedButton(onPressed: () async {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                        ),
                        child: const Text("Aggiungi", style: TextStyle(
                            color: Colors.black87),),
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
        CategoriaControl db = CategoriaControl();
        Navigator.pop(context);
        if(await db.deletePietanzaFromDB(widget.idCategoria, idPietanza) == "SUCCESSO") {
          setState((){});
          showAlertSuccesso("La pietanza è stata rimossa correttamente");
        }
        else {
          showAlertErrore("Non siamo riusciti ad rimuovere la pietanza, per favore riprova più tardi...");
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
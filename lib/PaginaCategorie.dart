import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataCategoria.dart';
import 'package:ingsw_frontend/SchermataVisualizzaConto.dart';
import 'package:ingsw_frontend/control/CategoriaControl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'GlobImport.dart';
import 'SchermataStoricoOrdinazioni.dart';
import 'entity/Utente.dart';

class PaginaCategorie extends StatefulWidget{
  final String title="PaginaCategorie";

  const PaginaCategorie({super.key});
  @override
  PaginaCategorieState createState() => PaginaCategorieState();

}

class PaginaCategorieState extends State<PaginaCategorie> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    generaWidgetCategorie() async {
      CategoriaControl db = CategoriaControl();
      List<dynamic>? listaCategorie = await db.getAllCategorieFromDB();
      if (listaCategorie != null) {
        return Align(
          alignment: Alignment.center,
          child: Wrap(
            direction: Axis.horizontal,
            runAlignment: WrapAlignment.center,
            runSpacing: 24,
            spacing: 24,
            children: List.generate(listaCategorie.length, (index) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7,
                            spreadRadius: 5,
                            color: Color(0xAA110505),
                            offset: Offset(-4, 4),
                          )
                        ],
                        color: Color(0xFFC89117),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SchermataCategoria(
                              nomeCategoria: listaCategorie![index]['nome'], idCategoria: listaCategorie![index]['id'])));
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
                              "${listaCategorie![index]['nome']}",
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 22,
                    right: 12,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(5.0), // Aggiunge i bordi arrotondati
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          showAlertConferma(listaCategorie?[index]['id']);
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                        ),
                        padding: EdgeInsets.zero, // Rimuove il padding predefinito dell'icona
                      ),
                    ),
                  ),
                ],
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
                      const Center(
                        child: Text(
                          'Categorie',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      ElevatedButton(onPressed: () async {
                        Utente utente = Utente();
                        if(utente.getRuolo == "AMMINISTRATORE" || utente.getRuolo == "SUPERVISORE") {

                        } else {
                          showAlertErrore("Non hai i permessi necessari per eseguire quest'operazione");
                        }
                      },
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
                              future: generaWidgetCategorie(),
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

  void showAlertErrore(String errore) {
    QuickAlert.show(context: context,
        type: QuickAlertType.error,
        text: errore,
        title: "Attenzione!"
    );
  }

  void showAlertConferma(int idPietanza) {
    QuickAlert.show(context: context,
      type: QuickAlertType.confirm,
      text: "",
      title: "Sei sicuro di voler eliminare questo elemento?",
      confirmBtnText: "Si",
      cancelBtnText: "No",
      onConfirmBtnTap: () async {
        CategoriaControl db = CategoriaControl();
        Navigator.pop(context);
        if(await db.deleteCategoriaFromDB(idPietanza) == "SUCCESSO") {
          setState((){});
          showAlertSuccesso("La categoria è stata eliminata correttamente");
        }
        else {
          showAlertErrore("Non siamo riusciti ad eliminare la categoria, per favore riprova più tardi...");
        }
      },
      onCancelBtnTap: () => Navigator.pop(context),
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
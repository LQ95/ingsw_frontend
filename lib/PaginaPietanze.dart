// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'GlobImport.dart';
import 'entity/Utente.dart';
import 'DatabaseControl.dart';

class PaginaPietanze extends StatefulWidget{
  final String title="PaginaPietanze";

  const PaginaPietanze({super.key});
  @override
  PaginaPietanzeState createState() => PaginaPietanzeState();

}

class PaginaPietanzeState extends State<PaginaPietanze> {

  //Popup per inserimento e modifica dati
  OverlayEntry? entry;
  bool overlayAperto = false;
  final controllerTitolo = TextEditingController();
  final controllerDescrizione = TextEditingController();
  final controllerAllergeni = TextEditingController();
  final controllerCosto = TextEditingController();

  @override
  Widget build(BuildContext context) {



    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    generaWidgetPietanze() async{

      DatabaseControl db = DatabaseControl();
      List<dynamic>? listaPietanze = await  db.getAllPietanzeFromDB();

      listaPietanze = listaPietanze?.reversed.toList();
      if (listaPietanze != null) {
        return Wrap(
          direction: Axis.vertical,
          children: List.generate(listaPietanze.length, (index) =>
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: SizedBox(height: 300,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(listaPietanze?[index]['name'], style: const TextStyle(fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Descrizione: " + listaPietanze?[index]['descrizione'], style: const TextStyle(
                                    color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Allergeni: " + listaPietanze?[index]['allergeni'], style: const TextStyle(
                                    color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(listaPietanze![index]['costo'].toString() + "€", style: const TextStyle(
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



    return GestureDetector(
      onTap: () => hideOverlay(),
      child: Scaffold(
        appBar: GlobalAppBar,
        drawer: globalDrawer,
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
                          if(overlayAperto){
                            overlayAperto = false;
                            hideOverlay();
                          }
                          Navigator.of(context).pop();
                        },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66420F),
                          ),
                          child: const Text("Torna Indietro", style: TextStyle(
                              color: Colors.white70),),
                        ),
                        ElevatedButton(onPressed: () {
                          Utente utente = Utente();
                          if ((utente.getRuolo == "AMMINISTRATORE" || utente.getRuolo == "SUPERVISORE") && overlayAperto == false) {
                            // Navigator.push(
                            //     localcontext, MaterialPageRoute(builder: (
                            //     context) => const SchermataScriviMessaggi()));
                            overlayAperto = true;
                            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => showOverlay());
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
      ),
    );
  }

  void showOverlay() {
    final overlay = Overlay.of(context)!;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    entry = OverlayEntry(builder: (context) => Positioned(
        width: size.width,
        height: size.height,
        child: buildOverlay()
    ),
    );

    overlay.insert(entry!);
  }

  Widget buildOverlay() {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FractionallySizedBox(
      widthFactor: 0.7,
      heightFactor: 0.7,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration( boxShadow: [
            BoxShadow(
              blurRadius: 7,
              spreadRadius: 5,
              color: Color(0xAA110505),
              offset: Offset(-8, 8),
            )
          ],
            color: Color(0xFFD9D9D9),
            //border: Border.all(width: 0),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Expanded(child:
                    Padding(
                    padding: const EdgeInsets.only(left: 64, right: 64),
                    child: TextField(
                      controller: controllerTitolo,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Titolo piatto:',
                      ),
                    ),),)
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Expanded(child:
                  Padding(
                    padding: const EdgeInsets.only(left: 64, right: 64),
                    child: TextField(
                      controller: controllerDescrizione,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descrizione:',
                      ),
                    ),),)
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Expanded(child:
                  Padding(
                    padding: const EdgeInsets.only(left: 64, right: 64),
                    child: TextField(
                      controller: controllerAllergeni,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Allergeni:',
                      ),
                    ),),)
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Expanded(child:
                  Padding(
                    padding: const EdgeInsets.only(left: 64, right: 64),
                    child: TextField(
                      controller: controllerCosto,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Prezzo:',
                      ),
                    ),),)
                  ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ElevatedButton(onPressed: () async {
                      if (controllerTitolo.text.isNotEmpty && controllerCosto.text
                          .isNotEmpty) {
                        DatabaseControl db = DatabaseControl();
                        String creazioneAvvenutaConSuccesso = await db.sendPietanzaToDb(
                            controllerTitolo.text, controllerDescrizione.text, controllerAllergeni.text, controllerCosto.text);  //Il client attende la risposta del server prima di proseguire, in modo che
                        if (creazioneAvvenutaConSuccesso == "SUCCESSO") {                                                               //il valore di ritorno di tipo Future ottenga uno stato
                          showAllertSuccesso();
                          hideOverlay();
                        } else if (creazioneAvvenutaConSuccesso == "FALLIMENTO"){
                          showAllertErrore("Ops, riprova...");
                          hideOverlay();
                        } else {
                          showAllertErrore("Si è verificato un errore inaspettato, per favore riprovare...");
                          hideOverlay();
                        }
                      }
                      else {
                        showAllertErrore(
                            "Attenzione, i campi non sono stati compilati correttamente!");
                            Navigator.pop(context);
                      }
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66420F),
                      ),
                      child: const Text("Conferma", style: TextStyle(
                          color: Colors.white70),),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  void hideOverlay() {
    controllerTitolo.text = "";
    controllerDescrizione.text = "";
    controllerAllergeni.text = "";
    controllerCosto.text = "";
    entry?.remove();
    entry = null;
    overlayAperto = false;
  }

  void showAllertErrore(String errore) {
    QuickAlert.show(context: context,
        type: QuickAlertType.error,
        text: errore,
        title: "Qualcosa è andato storto"
    );
  }


  void showAllertSuccesso() {
    QuickAlert.show(context: context,
        type: QuickAlertType.success,
        text: "Eccellente, il piatto è stato inserito con successo!",
        title: "Successo!",
        onConfirmBtnTap: () {Navigator.pop(context);}
    );
  }

}

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ingsw_frontend/control/UtenteControl.dart';
import 'package:quickalert/quickalert.dart';

import 'package:flutter/material.dart';
import 'MenuPrincipale.dart';
import 'entity/Utente.dart';


class SchermataCambioPassword extends StatefulWidget {


  final String title = "Te prego";

  const SchermataCambioPassword({super.key});

  @override
  SchermataCambioPasswordState createState() => SchermataCambioPasswordState();
}

class SchermataCambioPasswordState extends State<SchermataCambioPassword> {

  final controller1 = TextEditingController();
  final controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //sendPort.send(context);
    //ritrovano il testo immesso nei textfield
    double altezzaBox = 0.0;
    if (Platform.isAndroid){
      altezzaBox = 0.6;
    }
    else{
      altezzaBox = 0.7;
    }
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                  ),
                  SizedBox(
                    height: height*0.7,
                    width: width*0.7,
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
                          color: Color(0xFFC89117),
                          //border: Border.all(width: 0),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: height*0.65,
                                  maxWidth: width*0.7,
                                  minHeight: height*0.2,
                                  minWidth: width*0.2,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[Center(child:
                                      Expanded(child: Text("Benvenuto su Ratatouille23",
                                        style: TextStyle(fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,),)
                                      ),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(child: Text(
                                          "Questo è il primo accesso a questo account. Per favore inserisci una nuova Password",
                                          style: TextStyle(fontSize: 16, color: Colors.white60),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 64, right: 64,),
                                            child: TextFormField(
                                                controller: controller1,
                                                obscureText: true,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Nuova Password:',
                                                ),
                                                maxLength: 255,
                                                maxLengthEnforcement: MaxLengthEnforcement.enforced
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 64, right: 64,),
                                            child: TextFormField(
                                                controller: controller2,
                                                obscureText: true,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Conferma Password:',
                                                ),
                                                maxLength: 255,
                                                maxLengthEnforcement: MaxLengthEnforcement.enforced
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(onPressed: () async {
                                          if (controller1.text.isNotEmpty && controller2.text
                                              .isNotEmpty) {
                                            if(controller1.text != controller2.text){
                                              showAlertErrore(
                                                  "Attenzione, le password inserite sono diverse fra di loro!");
                                            }
                                            else {
                                              UtenteControl db = UtenteControl();
                                              Utente utente = Utente();
                                              try {
                                                db.updateUtenteData(utente.getNome, controller1.text, utente.getRuolo, utente.getId.toString());
                                                showAllertSuccesso();
                                              }
                                              catch (e) {
                                                showAlertErrore("C'è stato un problema di connessione con il server, riprova più tardi...");
                                              }
                                            }

                                          }
                                          else {
                                            showAlertErrore(
                                                "Attenzione, i campi non sono stati compilati correttamente!");
                                          }
                                        },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF66420F),
                                          ),
                                          child: const Text("Conferma", style: TextStyle(
                                              color: Colors.white70),),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                    ),
                  ),
                  Container(
                    height: 100,
                  ),
                ],
              ), // your column
            ),
          );
        },
      ),
    );
  }


  void showAlertErrore(String errore) {
    QuickAlert.show(context: context,
        type: QuickAlertType.error,
        text: errore,
        title: "Qualcosa è andato storto"
    );
  }


  void showAllertSuccesso() {
    QuickAlert.show(context: context,
        type: QuickAlertType.success,
        text: "Eccellente, la password è stata aggiornata correttamente!",
        title: "Successo!",
        onConfirmBtnTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPrincipale()));}
    );
  }
}
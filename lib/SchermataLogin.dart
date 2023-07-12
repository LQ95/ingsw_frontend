import 'dart:io';

import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';

import 'MenuPrincipale.dart';
import 'SchermataCambioPassword.dart';
import 'control/UtenteControl.dart';

class  SchermataLogin extends StatelessWidget{
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  static const double loginPadding=128.00;

  SchermataLogin({super.key});

  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();

    void showAlertErrore(String errore) {
      QuickAlert.show(context: context,
          type: QuickAlertType.error,
          text: errore,
          title: "Qualcosa è andato storto"
      );
    }


    void showAlertSuccesso() {
      QuickAlert.show(context: context,
          type: QuickAlertType.success,
          text: "Login effettuato.",
          title: "Successo!",
          onConfirmBtnTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const MenuPrincipale()));}
      );
    }

    void showAlertPrimoAccesso() {
      QuickAlert.show(context: context,
          type: QuickAlertType.success,
          text: "Login effettuato. dato che è la tua prima volta, ti chiediamo di cambiare password",
          title: "Successo!",
          onConfirmBtnTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const SchermataCambioPassword()));}
      );
    }
    return WillPopScope(onWillPop: ()=> exit(0),
      child:
      Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double larghezzaTextfield = 0.0;
            if (Platform.isAndroid){
              larghezzaTextfield= 0.5;
            }
            else{
              larghezzaTextfield = 0.2;
            }
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[Image(
                              image: const AssetImage('contents/images/Icona Ratatouille.png'),
                              width: width*0.2,
                              height: height*0.2,
                            ),]
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Center(child:
                          Expanded(child: Text("Login",
                            style: TextStyle(fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,),)
                          ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                                "Inserisci le tue credenziali:",
                                style: TextStyle(fontSize: 16, color: Colors.black,fontWeight:FontWeight.w400),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3)
                          ],
                        ),
                        Container(
                          height: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Expanded(child:
                                  FractionallySizedBox(
                                    widthFactor: larghezzaTextfield,
                                    child: TextField(
                                      controller: controller1,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Username:',
                                      ),
                                    ),),)
                                  ]
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Expanded(child:
                                  FractionallySizedBox(
                                    widthFactor: larghezzaTextfield,
                                    child: TextField(
                                      controller: controller2,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Password:',
                                      ),
                                    ),),)
                                  ]
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(onPressed: () async {                     //il valore di ritorno di tipo Future ottenga uno stato
                                    if (controller1.text.isNotEmpty && controller2.text
                                        .isNotEmpty) {
                                      UtenteControl db = UtenteControl();
                                      try {
                                        String esitoLogin = await db
                                            .sendLoginData(controller1.text,
                                            controller2
                                                .text); //Il client attende la risposta del server prima di proseguire, in modo che
                                        if (esitoLogin == "FALLIMENTO"){
                                          showAlertErrore("Le credenziali non sono corrette.");
                                        } else if (esitoLogin == 'primoAccesso') {
                                          showAlertPrimoAccesso();
                                        } else {
                                          showAlertSuccesso();
                                        }
                                      }
                                      on Exception{
                                        showAlertErrore("Errore interno del server");
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
                      ],
                    ),

                  ],
                ), // your column
              ),
            );
          },
        ),
      ),
    );
  }



}
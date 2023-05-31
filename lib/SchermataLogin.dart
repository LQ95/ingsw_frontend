import 'dart:io';

import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';

import 'DatabaseControl.dart';
import 'GlobImport.dart';
import 'MenuPrincipale.dart';
import 'entity/Utente.dart';

class  SchermataLogin extends StatelessWidget{
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  static const double loginPadding=128.00;

  SchermataLogin({super.key});

  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();

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
          text: "Login effettuato.",
          title: "Successo!",
          onConfirmBtnTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const MenuPrincipale()));}
      );
    }

    return WillPopScope(onWillPop: ()=> exit(0),
      child:
      Scaffold(
        appBar:GlobalAppBar,
        resizeToAvoidBottomInset: false,

        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.6,
            heightFactor: 0.8,
            alignment: FractionalOffset.topCenter,
            child: DecoratedBox(
                decoration: const BoxDecoration(

                  color: Color(0xFFeac953),


                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Expanded(child:
                          Padding(
                            padding: const EdgeInsets.only(left: 64, right: 64,),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 64, right: 64,),
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(onPressed: () async {                     //il valore di ritorno di tipo Future ottenga uno stato
                            if (controller1.text.isNotEmpty && controller2.text
                                .isNotEmpty) {
                              DatabaseControl db = DatabaseControl();
                              String creazioneAvvenutaConSuccesso = await db.sendLoginData(controller1.text, controller2.text);  //Il client attende la risposta del server prima di proseguire, in modo che
                              if (creazioneAvvenutaConSuccesso == "FALLIMENTO"){
                                showAllertErrore("Le credenziali non sono corrette.");
                              } else if (creazioneAvvenutaConSuccesso == "ERRORE INASPETTATO"){
                                showAllertErrore("Si è verificato un errore inaspettato, per favore riprovare...");
                              }
                              else  {
                                Utente utente = Utente();
                                utente.ruolo = creazioneAvvenutaConSuccesso;
                                utente.nome = controller1.text;
                                showAllertSuccesso();
                              }
                            }
                            else {
                              showAllertErrore(
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
                )
            ),
          ),
        ),
      ),
    );
  }



}
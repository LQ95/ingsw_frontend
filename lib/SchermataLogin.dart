import 'package:quickalert/quickalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DatabaseControl.dart';
import 'GlobImport.dart';

class  SchermataLogin extends StatelessWidget{
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {

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
          text: "Eccellente, l'account è stato creato con successo!",
          title: "Successo!",
          //onConfirmBtnTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SchermataBase("Mammt")));}
      );
    }

    return Scaffold(
      appBar:GlobalAppBar,
      resizeToAvoidBottomInset: false,
      // drawer: const Drawer(),
      // appBar: AppBar(title: Text(widget.title), actions: <Widget>[
      //   IconButton(
      //     icon: const Icon(Icons.settings),
      //     onPressed: () => {},
      //   )
      // ]),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: Text(
                    "Inserisci le tue credenziali",
                    style: TextStyle(fontSize: 16, color: Colors.white60),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,))
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
                        labelText: 'Nome Account:',
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
                  ElevatedButton(onPressed: () async {

                    if (controller1.text.isNotEmpty && controller2.text
                        .isNotEmpty) {
                      DatabaseControl db = DatabaseControl();
                      String creazioneAvvenutaConSuccesso = await db.sendLoginData(controller1.text, controller2.text);  //Il client attende la risposta del server prima di proseguire, in modo che
                      if (creazioneAvvenutaConSuccesso == "SUCCESSO") {                                                               //il valore di ritorno di tipo Future ottenga uno stato
                        showAllertSuccesso();
                      } else if (creazioneAvvenutaConSuccesso == "FALLIMENTO"){
                        showAllertErrore("Il nome che hai selezionato è già stato scelto...");
                      } else {
                        showAllertErrore("Si è verificato un errore inaspettato, per favore riprovare...");
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: Text(
                    "Attenzione, l'account così creato sarà quello di amministratore del sistema e non potrà essere modificato successivamente",
                    style: TextStyle(fontSize: 16,
                        color: Color(0xFFA52A70)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,))
                ],
              ),
            ],
          ),
        )
      ),
    );
  }



}
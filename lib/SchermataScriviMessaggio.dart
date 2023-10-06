import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'control/MessaggiControl.dart';
import 'topBar.dart';
import 'entity/Utente.dart';
import 'package:quickalert/quickalert.dart';

class SchermataScriviMessaggi extends StatefulWidget{
  final String title="SchermataScriviMessaggi"
  ;

  const SchermataScriviMessaggi({super.key});
  @override
  SchermataScriviMessaggiState createState() => SchermataScriviMessaggiState();

}

class SchermataScriviMessaggiState extends State<SchermataScriviMessaggi> {
  final controller1 = TextEditingController();
  Widget build(BuildContext context) {
    sendPort.send(Utente().getNome);

    showAlertNuoviMess(context);
    context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody:true,
      appBar:GlobalAppBar,
      drawer: buildDrawer(context),
      body:
    SingleChildScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    child:Center(
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(left: 18, top: 9, right: 18, bottom: 36),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: ()  {Navigator.of(context).pop();},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Torna Indietro", style: TextStyle(
                            color: Colors.white70),),
                      ),
                      ElevatedButton(onPressed: ()  {showAlertConferma();},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Pubblica", style: TextStyle(
                            color: Colors.white70),),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                      controller: controller1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      minLines: 12,
                      maxLines: 20,
                      style: const TextStyle(color: Colors.black87),
                      maxLength: 2048,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced
                  ),
                )
              ]
          )
      ),
    ),
    );
  }


  void showAlertConferma() {
    QuickAlert.show(context: context,
      type: QuickAlertType.confirm,
      text: "Sei sicuro di voler inviare questo messaggio?",
      title: "Conferma",
      confirmBtnText: "Si",
      cancelBtnText: "No",
      onConfirmBtnTap: () async {
        MessaggiControl db = MessaggiControl();
        Utente utente = Utente();
        try {
          await db.sendMessaggioToDb(utente.getNome, controller1.text);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } catch (e) {
          showAlertErrore("Il messaggio non è stato inviato correttamente, per favore riprova più tardi...");
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
}
import 'package:flutter/material.dart';
import 'package:ingsw_frontend/control/MessaggiControl.dart';
import 'GlobImport.dart';
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
    print("manda stringa");
    sendPort.send(Utente().getNome);
    print("costruisce widget");
    showAlertNuoviMess(context);
    context;
    return Scaffold(
      appBar:GlobalAppBar,
      drawer: buildDrawer(context),
      body:  Center(
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
                    minLines: 10,
                    maxLines: 20,
                    style: const TextStyle(color: Colors.black87),
                  ),
                )
              ]
          )
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
        String result = await db.sendMessaggioToDb(utente.getNome, controller1.text);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      onCancelBtnTap: () => Navigator.pop(context),
    );
  }
}
import 'package:quickalert/quickalert.dart';

import 'DatabaseControl.dart';
import 'package:flutter/material.dart';


class InitAmministratoreHomePage extends StatefulWidget {


  final String title = "Te prego";

  const InitAmministratoreHomePage({super.key});

  @override
  InitAmministratoreHomePageState createState() => InitAmministratoreHomePageState();
}

class InitAmministratoreHomePageState extends State<InitAmministratoreHomePage> {
  //Ma

  @override
  Widget build(BuildContext context) {
    //ritrovano il testo immesso nei textfield
    final controller1= TextEditingController();
    final controller2= TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: const Drawer(),
      // appBar: AppBar(title: Text(widget.title), actions: <Widget>[
      //   IconButton(
      //     icon: const Icon(Icons.settings),
      //     onPressed: () => {},
      //   )
      // ]),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.7,
          heightFactor: 0.7,
          alignment: FractionalOffset.topCenter,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Center(child:
                        Expanded(child: Text("Benvenuto su Ratatouille23", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis,),)
                      ),
                        ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[ Expanded(child: Text("Inserisci le seguenti informazioni per inizializzare il sistema!", style: TextStyle(fontSize: 16, color: Colors.white60), overflow: TextOverflow.ellipsis, maxLines: 3,))
                  ],
                ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Expanded( child:
                        Padding(
                          padding: const EdgeInsets.only(left: 64, right: 64,),
                          child:TextField(
                            controller: controller1,
                            decoration:  const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nome Account:',
                            ),
                          ),),)]
                    ),
                     Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Expanded( child:
                          Padding(
                          padding: const EdgeInsets.only(left: 64, right: 64,),
                          child:TextField(
                              controller: controller2,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password:',
                            ),
                          ),),)]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(onPressed: (){
                          if(controller1.text.isNotEmpty && controller2.text.isNotEmpty) {
                            DatabaseControl db = DatabaseControl(); db.sendData(controller1.text,controller2.text, "AMMINISTRATORE");
                            }
                          else {
                            showAllert();
                          }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66420F),
                            ),
                          child: const Text("Conferma", style: TextStyle(color: Colors.white70),),
                        )
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[ Expanded(child: Text("Attenzione, l'account così creato sarà quello di amministratore del sistema e non potrà essere modificato successivamente", style: TextStyle(fontSize: 16, color: Color(0xFFA52A70)), overflow: TextOverflow.ellipsis, maxLines: 3,))
                      ],
                    ),
                  ],
                ),
                  )
          ),
        ),
      ),
    );
  }


  void showAllert() {
    QuickAlert.show(context: context,
    type: QuickAlertType.error,
    text: "Attenzione, i campi non sono stati compilati correttamente!",
    title: "Errore"
    );
  }
}

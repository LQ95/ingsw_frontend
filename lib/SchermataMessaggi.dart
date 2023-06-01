import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataScriviMessaggio.dart';
import 'GlobImport.dart';
import 'entity/Utente.dart';

class SchermataMessaggi extends StatefulWidget{
  final String title="SchermataMessaggi"
  ;

  const SchermataMessaggi({super.key});
  @override
  SchermataMessaggiState createState() => SchermataMessaggiState();

}

class SchermataMessaggiState extends State<SchermataMessaggi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:GlobalAppBar,
      drawer: globalDrawer,
      body:  Center(
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(left: 18, top: 9, right: 18),
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
                      ElevatedButton(onPressed: ()  {
                        Utente utente = Utente();
                        if(utente.getRuolo == "AMMINISTRATORE"){
                          Navigator.push(localcontext, MaterialPageRoute(builder: (context) =>const SchermataScriviMessaggi()));
                        }
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Scrivi", style: TextStyle(
                            color: Colors.white70),),
                      ),
                    ],
                  ),
                ),
                // Center(
                //     child:

                // )
              ]
          )
      ),
    );
  }
}
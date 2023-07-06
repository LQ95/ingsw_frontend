import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataCreazioneAccount.dart';
import 'GlobImport.dart';
import 'SchermataStatistiche.dart';

class SchermataFunzioniAmministratore extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    //sendPort.send(context);
    return Scaffold(
      appBar:GlobalAppBar,
      drawer: buildDrawer(context),
      body:  Center(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(left: 18, top: 9),
                child:
                ElevatedButton(onPressed: ()  {Navigator.of(context).pop();},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66420F),
                  ),
                  child: const Text("Torna Indietro", style: TextStyle(
                      color: Colors.white70),),
                ),
              ),
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SchermataStatistiche()));},
                        child: Ink.image(
                          image: const AssetImage('contents/images/Bottone statistiche.png'),
                          width: width*0.4,
                          height: height*0.4,
                        ),
                      ),
                      InkWell(
                        onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SchermataCreazioneAccount()));},
                        child: Ink.image(
                          image: const AssetImage('contents/images/Bottone Creazione Account.png'),
                          width: width*0.4,
                          height: height*0.4,
                        ),
                      ),
                    ]
                ),
              ),
            ],
          )
      ),
    );
  }
}
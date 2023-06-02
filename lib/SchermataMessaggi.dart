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
    //Calcolo dell'altezza dello schermo
    double width = MediaQuery.of(context).size.width;

    generaWidget(int righe, List<String> mittenti, List<String> messaggi){
      return Wrap(
        direction: Axis.vertical,
        children: List.generate(righe, (index) =>
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: SizedBox(height: 300,
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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: Text(mittenti[index], overflow: TextOverflow.ellipsis, maxLines: 1,),),
                            Text(messaggi[index], overflow: TextOverflow.ellipsis, maxLines: 12,)
                          ]
                      ),
                    ),
                  )
              ),
            ),),
      );
    }

    return Scaffold(
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
                        if (utente.getRuolo == "AMMINISTRATORE") {
                          Navigator.push(
                              localcontext, MaterialPageRoute(builder: (
                              context) => const SchermataScriviMessaggi()));
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
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            generaWidget(3, ["Franco", "Flavia", "Paolo"], ["Prova 1", "Prova 2", "Prova 3"]),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]
          )
      ),
    );
  }

/*Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 300,
                                width: width*0.7,
                                child: const DecoratedBox(
                                  decoration: BoxDecoration(
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
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Center(child: Text("Franco"),),
                                        Text("Ti prego funziona e appari decentemente!")
                                      ]
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )*/

}
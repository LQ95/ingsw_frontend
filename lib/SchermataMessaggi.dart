import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataScriviMessaggio.dart';
import 'GlobImport.dart';
import 'entity/Utente.dart';
import 'DatabaseControl.dart';

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

    generaWidgetMessaggi() async{

      DatabaseControl db = DatabaseControl();
      List<dynamic>? listaMessaggi = await  db.getAllMessaggiFromDB();
      listaMessaggi = listaMessaggi?.reversed.toList();
      if (listaMessaggi != null) {
        return Wrap(
          direction: Axis.vertical,
          children: List.generate(listaMessaggi.length, (index) =>
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: SizedBox(height: 300,
                    width: width * 0.7,
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
                              Center(child: Text(listaMessaggi?[index]['mittente'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,),),
                              Text(listaMessaggi?[index]['corpo'], overflow: TextOverflow
                                  .ellipsis, maxLines: 12,)
                            ]
                        ),
                      ),
                    )
                ),
              ),),
        );
      }
      else {
        return const Text("");
      }
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
                        if (utente.getRuolo == "AMMINISTRATORE" || utente.getRuolo == "SUPERVISORE") {
                          Navigator.push(
                              localcontext, MaterialPageRoute(builder: (
                              context) => const SchermataScriviMessaggi())).then((value) => setState(() {}));
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
                          children: [
                            FutureBuilder(
                              future: generaWidgetMessaggi(),
                              builder: (context, snapshot){
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError){
                                  return Text(snapshot.error.toString());
                                } else {
                                  return snapshot.data!;
                                }
                              },
                            )
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



}
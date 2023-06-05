import 'package:flutter/material.dart';
import 'GlobImport.dart';
import 'entity/Utente.dart';
import 'DatabaseControl.dart';

class PaginaPietanze extends StatefulWidget{
  final String title="PaginaPietanze";

  const PaginaPietanze({super.key});
  @override
  PaginaPietanzeState createState() => PaginaPietanzeState();

}

class PaginaPietanzeState extends State<PaginaPietanze> {
  @override
  Widget build(BuildContext context) {


    double width = MediaQuery.of(context).size.width;

    generaWidgetPietanze() async{

      DatabaseControl db = DatabaseControl();
      List<dynamic>? listaPietanze = await  db.getAllPietanzeFromDB();

      listaPietanze = listaPietanze?.reversed.toList();
      if (listaPietanze != null) {
        return Wrap(
          direction: Axis.vertical,
          children: List.generate(listaPietanze.length, (index) =>
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
                        color: Color(0xFF728514),
                        //border: Border.all(width: 0),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(listaPietanze?[index]['name'], style: const TextStyle(fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Descrizione: " + listaPietanze?[index]['descrizione'], style: const TextStyle(
                                    color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Allergeni: " + listaPietanze?[index]['allergeni'], style: const TextStyle(
                                    color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(listaPietanze![index]['costo'].toString() + "€", style: const TextStyle(
                                    color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          ],
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
                          // Navigator.push(
                          //     localcontext, MaterialPageRoute(builder: (
                          //     context) => const SchermataScriviMessaggi()));
                        }
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Aggiungi", style: TextStyle(
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
                              future: generaWidgetPietanze(),
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
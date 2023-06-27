import 'dart:ffi';

import 'package:flutter/material.dart';
import 'GlobImport.dart';
import 'SchermataSelezionaCategoria.dart';

class SchermataStoricoOrdinazioni extends StatefulWidget{
  final String title="SchermataStoricoOrdinazioni";
  final Long idTavolo;

  const SchermataStoricoOrdinazioni({required this.idTavolo, super.key});
  @override
  SchermataStoricoOrdinazioniState createState() => SchermataStoricoOrdinazioniState(this.idTavolo);

}

class SchermataStoricoOrdinazioniState extends State<SchermataStoricoOrdinazioni> {
  final Long idTavolo;

  SchermataStoricoOrdinazioniState(this.idTavolo);



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: GlobalAppBar,
      drawer: buildDrawer(context),
      body: Center(
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 9, right: 18),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Tavolo n° ${widget.idTavolo}",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 32,
                            ),
                          ),
                          const Text(
                            "Storico delle ordinazioni",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Center(
                      child: SizedBox(
                        width: width * 0.9,
                        height: height * 0.7,
                        child: const SingleChildScrollView(
                          child: Column(
                            children: [
                              // FutureBuilder(
                              //   future: generaWidgetTavoli(),
                              //   builder: (context, snapshot){
                              //     if (snapshot.connectionState == ConnectionState.waiting) {
                              //       return const CircularProgressIndicator();
                              //     }
                              //     if (snapshot.hasError){
                              //       return Text(snapshot.error.toString());
                              //     } else {
                              //       return snapshot.data!;
                              //     }
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text(
                          "Indietro",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: FloatingActionButton(
                        shape: const CircleBorder(),
                        onPressed: () {
                          // Azione da eseguire quando viene premuto il FAB
                          Navigator.push(
                          context,
                                  MaterialPageRoute(builder: (context) => SchermataSelezionaCategoria(idTavolo: idTavolo)
                                  )
                                          );
                            },
                        backgroundColor: const Color(0xFF728514),
                        child: Icon(Icons.add), // Icona del FAB
                      ),
                    ),
                  ],
                ),

              ]
          )
      ),
    );
  }

}
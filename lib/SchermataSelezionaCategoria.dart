import 'dart:ffi';

import 'package:flutter/material.dart';

import 'GlobImport.dart';
import 'SchermataSelezionaPietanza.dart';
import 'control/CategoriaControl.dart';

class SchermataSelezionaCategoria extends StatelessWidget{
  final int idTavolo;
  final int idOrdinazione;

  const SchermataSelezionaCategoria({super.key, required this.idTavolo, required this.idOrdinazione});


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    generaWidgetCategorie() async {
      CategoriaControl db = CategoriaControl();
      List<dynamic>? listaCategorie = await db.getAllCategorieFromDB();
      if (listaCategorie != null) {
        return Align(
          alignment: Alignment.center,
          child: Wrap(
            direction: Axis.horizontal,
            runAlignment: WrapAlignment.center,
            runSpacing: 24,
            spacing: 24,
            children: List.generate(listaCategorie.length, (index) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7,
                            spreadRadius: 5,
                            color: Color(0xAA110505),
                            offset: Offset(-4, 4),
                          )
                        ],
                        color: Color(0xFFC89117),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SchermataSelezionaPietanza(
                              nomeCategoria: listaCategorie![index]['nome'], idCategoria: listaCategorie![index]['id'],idTavolo: idTavolo,idOrdinazione:idOrdinazione)));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 7,
                          backgroundColor: const Color(0xFFC89117),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(
                              color: Colors.black.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: SizedBox(
                          height: height * 0.15,
                          width: width * 0.25,
                          child: Center(
                            child: Text(
                              "${listaCategorie![index]['nome']}",
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              );
            }),
          ),
        );
      } else {
        return const Text("");
      }
    }

    return Scaffold(
        appBar: GlobalAppBar,
        drawer: buildDrawer(context),
        body: Center(child:
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        const Padding(
        padding: EdgeInsets.only(left: 18, top: 9, right: 18),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Seleziona categoria",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 32,
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            FutureBuilder(
                              future: generaWidgetCategorie(),
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
                            ),
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
                ],
              ),

            ]
        )));

  }

}


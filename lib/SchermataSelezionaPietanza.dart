import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GlobImport.dart';
import 'control/CategoriaControl.dart';

class SchermataSelezionaPietanza extends StatelessWidget{
  final String nomeCategoria;
  final int idCategoria;

  const SchermataSelezionaPietanza({super.key, required this.nomeCategoria, required this.idCategoria});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    generaWidgetPietanze() async{


      CategoriaControl dbCat = CategoriaControl();
      List<dynamic>? listaPietanze = await  dbCat.getPietanzeFromCategoria(idCategoria);
      print(listaPietanze);
      listaPietanze = listaPietanze?.reversed.toList();
      if (listaPietanze != null) {
        return Wrap(
          direction: Axis.vertical,
          children: List.generate(listaPietanze.length, (index) =>
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: SizedBox(
                    height: 300,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                SizedBox(
                                  width: width * 0.45,
                                  child: Text(
                                    listaPietanze?[index]['name'],
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF66420F),
                                  ),
                                  child: const Text("Placeholder per il contatore", style: TextStyle(
                                      color: Colors.white70),),
                                )

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



    return  Scaffold(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: () {
                        Navigator.of(context).pop();
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Indietro", style: TextStyle(
                            color: Colors.white70),),
                      ),
                      const Center(
                        child: Text(
                          'Scegli quale pietanza aggiungere',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 32,
                          ),
                        ),
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
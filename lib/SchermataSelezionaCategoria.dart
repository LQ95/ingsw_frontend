import 'package:flutter/material.dart';

import 'GlobImport.dart';

class SchermataSelezionaCategoria extends StatelessWidget{
  final String idTavolo;

  const SchermataSelezionaCategoria({super.key, required this.idTavolo});


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                ],
              ),

            ]
        )));

  }

}
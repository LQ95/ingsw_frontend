import 'package:flutter/material.dart';
import 'GlobImport.dart';

class SchermataVisualizzaConto extends StatefulWidget{
  final String title="SchermataVisualizzaConto";
  final String idTavolo;

  const SchermataVisualizzaConto({required this.idTavolo, super.key});
  @override
  SchermataVisualizzaContoState createState() => SchermataVisualizzaContoState();

}

class SchermataVisualizzaContoState extends State<SchermataVisualizzaConto> {

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: GlobalAppBar,
      drawer: globalDrawer,
      body: Center(
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 18, top: 9, right: 18),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        "Conto tavolo ${widget.idTavolo}",
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 32,
                        ),
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
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: SingleChildScrollView(
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
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66420F),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Chiudi",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                "ordinazione",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 50,
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
                    ),
                  ],
                ),

              ]
          )
      ),
    );
  }

}
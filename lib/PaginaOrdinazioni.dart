import 'package:flutter/material.dart';
import 'GlobImport.dart';
import 'DatabaseControl.dart';

class PaginaOrdinazioni extends StatefulWidget{
  final String title="PaginaOrdinazioni";

  const PaginaOrdinazioni({super.key});
  @override
  PaginaOrdinazioniState createState() => PaginaOrdinazioniState();

}

class PaginaOrdinazioniState extends State<PaginaOrdinazioni> {


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    generaWidgetTavoli() async {
      DatabaseControl db = DatabaseControl();
      List<dynamic>? listaTavoli = await db.getAllTavoliFromDB();
      listaTavoli = listaTavoli?.reversed.toList();
      if (listaTavoli != null) {
        return Wrap(
          direction: Axis.vertical,
          runAlignment: WrapAlignment.center,
          runSpacing: 24,
          children: List.generate(listaTavoli.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: SizedBox(
                height: height * 0.15,
                width: width * 0.25,
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
                    child: Text(
                      "Tavolo${listaTavoli![index]['id']}",
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      } else {
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
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                        ),
                        child: const Text("Rimuovi Tavolo", style: TextStyle(
                            color: Colors.black87),),
                      ),
                      const Text(
                        'Ordinazioni',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 28,
                        ),
                      ),
                      ElevatedButton(onPressed: () {
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                        ),
                        child: const Text("Aggiungi Tavolo", style: TextStyle(
                            color: Colors.black87),),
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
                            SizedBox(
                              height: height*0.8,
                              width: double.infinity,
                              child: FutureBuilder(
                                future: generaWidgetTavoli(),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Indietro", style: TextStyle(
                            color: Colors.white70),),
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
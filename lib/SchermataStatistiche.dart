import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataCreazioneAccount.dart';
import 'package:ingsw_frontend/control/StatisticheControl.dart';
import 'GlobImport.dart';

class SchermataStatistiche extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();


    Future<Widget> generaGrafico() async {
      StatisticheControl db = StatisticheControl();
      Map<DateTime, double> stats = await db.getClosedOrdinazioniFromDB();

      // Genera una stringa con le righe della mappa
      String result = stats.entries.map((entry) => "${entry.key}: ${entry.value}").join('\n');

      return Text(result);
    }




    return Scaffold(
      appBar:GlobalAppBar,
      drawer: buildDrawer(context),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
            ],
          ),
          // FutureBuilder(
          //   future: generaGrafico(),
          //   builder: (context, snapshot){
          //     if (snapshot.connectiNo, al onState == ConnectionState.waiting) {
          //       return const CircularProgressIndicator();
          //     }
          //     if (snapshot.hasError){
          //       return Text(snapshot.error.toString());
          //     } else {
          //       return snapshot.data!;
          //     }
          //   },
          // )
          Padding(padding: const EdgeInsets.only(left: 18, top: 9),
            child:
            ElevatedButton(onPressed: ()  async {
              StatisticheControl db = StatisticheControl();
              var res = await db.getClosedOrdinazioniFromDB();
              print(res);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66420F),
              ),
              child: const Text("Stampa roba", style: TextStyle(
                  color: Colors.white70),),
            ),
          ),
        ],
      ),
    );
  }
}
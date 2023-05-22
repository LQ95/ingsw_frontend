import 'package:flutter/material.dart';

class InitAmministratoreHomePage extends StatefulWidget {
  final String title = "Te prego";

  const InitAmministratoreHomePage({super.key});

  @override
  InitAmministratoreHomePageState createState() => InitAmministratoreHomePageState();
}

class InitAmministratoreHomePageState extends State<InitAmministratoreHomePage> {
  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    String aspectRatio =
        MediaQuery.of(context).size.aspectRatio.toStringAsFixed(4);
    Orientation orientation = MediaQuery.of(context).orientation;

    return const Scaffold(
      // drawer: const Drawer(),
      // appBar: AppBar(title: Text(widget.title), actions: <Widget>[
      //   IconButton(
      //     icon: const Icon(Icons.settings),
      //     onPressed: () => {},
      //   )
      // ]),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.6,
          heightFactor: 0.6,
          alignment: FractionalOffset.topCenter,
          child: DecoratedBox(
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
                  padding: EdgeInsets.all(32),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Benvenuto su Ratatouille23", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),),
                      ],
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[Text("Inserisci le seguenti informazioni per inizializzare il sistema!", style: TextStyle(fontSize: 16, color: Colors.white60),)
                  ],
                ),
                  ],
                ),
                  )
          ),
        ),
      ),
    );
  }
}

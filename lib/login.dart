import 'package:flutter/material.dart';


class LoginHomePage extends StatefulWidget{
  final String title = "Te prego";

  const LoginHomePage({super.key});

  @override
  LoginHomePageState createState() => LoginHomePageState();

}

class LoginHomePageState extends State <LoginHomePage> {
  @override
  Widget build(BuildContext context) {

    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    String aspectRatio = MediaQuery.of(context).size.aspectRatio.toStringAsFixed(4);
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => {},
            )
          ]
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(64),
            child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(64),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            const Column( children: <Widget>[Text("Width:"), Text("Height;")],),
                            Column( children: <Widget>[Text(width.toString()), Text(height.toString())],),
                            const Column( children: <Widget>[Text("PR:"), Text("AR;")],),
                            Column( children: <Widget>[Text(devicePixelRatio.toString()), Text(aspectRatio)],),
                          ],
                        ),
                        Text(orientation.toString()),
                      ],
                    )
                )
            ),
          ),
        ],
      ),
    );
  }
}
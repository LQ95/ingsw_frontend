import 'package:flutter/material.dart';

class LoginHomePage extends StatefulWidget {
  final String title = "Te prego";

  const LoginHomePage({super.key});

  @override
  LoginHomePageState createState() => LoginHomePageState();
}

class LoginHomePageState extends State<LoginHomePage> {
  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    String aspectRatio =
        MediaQuery.of(context).size.aspectRatio.toStringAsFixed(4);
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
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
              decoration: const BoxDecoration(
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
                  padding: const EdgeInsets.all(64),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const Column(
                            children: <Widget>[Text("Width:"), Text("Height;")],
                          ),
                          Column(
                            children: <Widget>[
                              Text(width.toString()),
                              Text(height.toString())
                            ],
                          ),
                          const Column(
                            children: <Widget>[Text("PR:"), Text("AR;")],
                          ),
                          Column(
                            children: <Widget>[
                              Text(devicePixelRatio.toString()),
                              Text(aspectRatio)
                            ],
                          ),
                        ],
                      ),
                      Text(orientation.toString()),
                    ],
                  ))),
        ),
      ),
    );
  }
}

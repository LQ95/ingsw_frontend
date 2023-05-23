import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class InitAmministratoreHomePage extends StatefulWidget {


  final String title = "Te prego";

  const InitAmministratoreHomePage({super.key});

  @override
  InitAmministratoreHomePageState createState() => InitAmministratoreHomePageState();
}

class InitAmministratoreHomePageState extends State<InitAmministratoreHomePage> {
  //Ma
  void sendData(String name, String pass) async {
    var apiUrl=Uri.http('localhost:8080','/api/v1/utente'); //URL del punto di contatto della API
    var response = await http.post(apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:jsonEncode(<String, String>{'nome': name,
          'password': pass,
          'ruolo':'AMMINISTRATORE'})
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    //ritrovano il testo immesso nei textfield
    final Controller1= TextEditingController();
    final Controller2= TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: const Drawer(),
      // appBar: AppBar(title: Text(widget.title), actions: <Widget>[
      //   IconButton(
      //     icon: const Icon(Icons.settings),
      //     onPressed: () => {},
      //   )
      // ]),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.7,
          heightFactor: 0.7,
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
                  padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Center(child:
                        Expanded(child: Text("Benvenuto su Ratatouille23", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis,),)
                      ),
                        ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[ Expanded(child: Text("Inserisci le seguenti informazioni per inizializzare il sistema!", style: TextStyle(fontSize: 16, color: Colors.white60), overflow: TextOverflow.ellipsis, maxLines: 3,))
                  ],
                ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Expanded( child:
                        Padding(
                          padding: EdgeInsets.only(left: 64, right: 64,),
                          child:TextField(
                            controller: Controller1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nome Account:',
                            ),
                          ),),)]
                    ),
                     Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Expanded( child:
                          Padding(
                          padding: EdgeInsets.only(left: 64, right: 64,),
                          child:TextField(
                              controller: Controller2,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password:',
                            ),
                          ),),)]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(onPressed: (){ sendData(Controller1.text,Controller2.text);},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66420F),
                            ),
                          child: const Text("Conferma", style: TextStyle(color: Colors.white70),),
                        )
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[ Expanded(child: Text("Attenzione, l'account così creato sarà quello di amministratore del sistema e non potrà essere modificato successivamente", style: TextStyle(fontSize: 16, color: Color(0xFFA52A70)), overflow: TextOverflow.ellipsis, maxLines: 3,))
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

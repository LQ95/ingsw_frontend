import 'package:flutter/material.dart';
import 'GlobImport.dart';
import "PaginaCategorie.dart";
import "PaginaPietanze.dart";

class PaginaMenu extends StatefulWidget{
  final String title="PaginaMenu";

  const PaginaMenu({super.key});
  @override
  PaginaMenuState createState() => PaginaMenuState();

}

class PaginaMenuState extends State<PaginaMenu> {
  @override
  Widget build(BuildContext context) {
    //sendPort.send(context);
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    return Scaffold(
      appBar:GlobalAppBar,
      drawer: buildDrawer(context),
      body:  Center(
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                // Center(
                //     child:
                    Expanded(
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaCategorie()));},
                                child: Ink.image(
                                  image: const AssetImage('contents/images/Bottone Categorie.png'),
                                  width: width*0.4,
                                  height: height*0.4,
                                ),
                              ),
                              InkWell(
                                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaPietanze()));},
                                child: Ink.image(
                                  image: const AssetImage('contents/images/Bottone Pietanze.png'),
                                  width: width*0.4,
                                  height: height*0.4,
                                ),
                              ),
                            ]
                        )
                    )
                // )
              ]
          )
      ),
    );
  }
}
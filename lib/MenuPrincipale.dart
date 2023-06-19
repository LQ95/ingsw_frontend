import 'package:flutter/material.dart';
import 'package:ingsw_frontend/PaginaMenu.dart';
import 'package:ingsw_frontend/PaginaOrdinazioniTavoli.dart';
import 'GlobImport.dart';

class MenuPrincipale extends StatefulWidget{
  final String title="MenuPrincipale";

  const MenuPrincipale({super.key});
  @override
  MenuPrincipaleState createState() => MenuPrincipaleState();

}


class MenuPrincipaleState extends State<MenuPrincipale>{
  @override
  Widget build(BuildContext context) {

    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    return WillPopScope(onWillPop: () async => false,
      child:
      Scaffold(
        appBar:GlobalAppBar,
        drawer: buildDrawer(context),
        body:  Center(
            child:
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaOrdinazioniTavoli()));},
                    child: Ink.image(
                      image: const AssetImage('contents/images/Bottone Ordinazioni.png'),
                      width: width*0.4,
                      height: height*0.4,
                    ),
                  ),
                  InkWell(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaMenu()));},
                    child: Ink.image(
                      image: const AssetImage('contents/images/Bottone Menù.png'),
                      width: width*0.4,
                      height: height*0.4,
                    ),
                  ),
                ]
            )
        ),
      ),
    );
  }
}
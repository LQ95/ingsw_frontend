import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar:GlobalAppBar,
      drawer: globalDrawer,
      body:  Center(
        child:
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {},
              child: Ink.image(
                image: const AssetImage('contents/images/Bottone Ordinazioni.png'),
                width: width*0.4,
                height: height*0.4,
              ),
            ),
            InkWell(
              onTap: () {},
              child: Ink.image(
                image: const AssetImage('contents/images/Bottone Menù.png'),
                width: width*0.4,
                height: height*0.4,
              ),
            ),
          ]
        )
      ),
    );
  }
}
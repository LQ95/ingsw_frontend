import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataCreazioneAccount.dart';
import 'GlobImport.dart';

class SchermataFunzioniAmministratore extends StatelessWidget{
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
                    image: const AssetImage('contents/images/Bottone Statistiche.png'),
                    width: width*0.4,
                    height: height*0.4,
                  ),
                ),
                InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SchermataCreazioneAccount()));},
                  child: Ink.image(
                    image: const AssetImage('contents/images/Bottone Creazione Account.png'),
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
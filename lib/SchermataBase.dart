
import 'package:flutter/material.dart';

class SchermataBase extends StatelessWidget{
  String title="";

  SchermataBase(String title){
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title: Text(this.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => {},
            )
          ]
      ),
    );
  }

}
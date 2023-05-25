
import 'package:flutter/material.dart';
import 'GlobImport.dart';

class SchermataBase extends StatelessWidget{
  String title="";

  SchermataBase(String title){
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:GlobalAppBar,
    );
  }

}
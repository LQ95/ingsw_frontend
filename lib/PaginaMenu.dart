import 'package:flutter/material.dart';
import 'GlobImport.dart';

class PaginaMenu extends StatefulWidget{
  final String title="PaginaMenu";

  const PaginaMenu({super.key});
  @override
  PaginaMenuState createState() => PaginaMenuState();

}

class PaginaMenuState extends State<PaginaMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:GlobalAppBar,
        drawer: globalDrawer,
        body:  Center(
      )
    );
  }
}
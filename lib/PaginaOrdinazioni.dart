import 'package:flutter/material.dart';
import 'GlobImport.dart';

class PaginaOrdinazioni extends StatefulWidget{
  final String title="PaginaOrdinazioni";

  const PaginaOrdinazioni({super.key});
  @override
  PaginaOrdinazioniState createState() => PaginaOrdinazioniState();

}

class PaginaOrdinazioniState extends State<PaginaOrdinazioni> {
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
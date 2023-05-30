import 'package:flutter/material.dart';
import 'GlobImport.dart';

class PaginaCategorie extends StatefulWidget{
  final String title="PaginaCategorie";

  const PaginaCategorie({super.key});
  @override
  PaginaCategorieState createState() => PaginaCategorieState();

}

class PaginaCategorieState extends State<PaginaCategorie> {
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
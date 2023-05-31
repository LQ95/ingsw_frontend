import 'package:flutter/material.dart';
import 'GlobImport.dart';

class PaginaPietanze extends StatefulWidget{
  final String title="PaginaPietanze";

  const PaginaPietanze({super.key});
  @override
  PaginaPietanzeState createState() => PaginaPietanzeState();

}

class PaginaPietanzeState extends State<PaginaPietanze> {
  @override
  Widget build(BuildContext context) {
    localcontext=context;
    return Scaffold(
        appBar:GlobalAppBar,
        drawer: globalDrawer,
        body:  Center(
        )
    );
  }
}
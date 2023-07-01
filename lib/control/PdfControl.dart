import 'dart:ffi';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;

class PdfControl{

  static createPdfConto(List<dynamic> pietanze, int tavoloId,double conto) async {
  final pdf= pdfWidgets.Document();
  pdf.addPage(pdfWidgets.Page(
    pageFormat: PdfPageFormat.a4,
    build: (pdfWidgets.Context context){
      return pdfWidgets.Center(
        child: pdfWidgets.Column(
          children:[
            pdfWidgets.Text('Conto Tavolo n°$tavoloId',style: const pdfWidgets.TextStyle(fontSize: 40)),
            pdfWidgets.ListView.builder(itemCount: pietanze.length,itemBuilder: (context,index){
              return pdfWidgets.Row(
                children: [
                  pdfWidgets.Expanded(
                      child:pdfWidgets.Text(pietanze[index]['name'],style: const pdfWidgets.TextStyle(fontSize: 14))
                  ),
                  pdfWidgets.Text(pietanze[index]['costo'] + "€",style: const pdfWidgets.TextStyle(fontSize: 14))
                ]
              );
            }),
          pdfWidgets.Row(
              children: [
                pdfWidgets.Text("$conto€",style: const pdfWidgets.TextStyle(fontSize: 14)),
              ]
          )
          ]
        )
      );

    }
  ));

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/conto.pdf");
  }

}
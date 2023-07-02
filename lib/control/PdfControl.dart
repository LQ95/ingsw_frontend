import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:printing/printing.dart';

class PdfControl{

  static createPdfConto(List<dynamic> pietanze, String tavoloId,double conto) async {
    var data = await rootBundle.load("contents/fonts/Calibri.ttf");
    final font =  pdfWidgets.Font.ttf(data.buffer.asByteData());
  final pdf= pdfWidgets.Document();
  pdf.addPage(pdfWidgets.Page(
    pageFormat: PdfPageFormat.a4,
    build: (pdfWidgets.Context context){
      return pdfWidgets.Center(
        child: pdfWidgets.Column(
          children:[
            pdfWidgets.Text('Conto Tavolo n°$tavoloId',style: pdfWidgets.TextStyle(font: font,fontSize: 40)),
            pdfWidgets.ListView.builder(itemCount: pietanze.length,itemBuilder: (context,index){
              return pdfWidgets.Row(
                children: [
                  pdfWidgets.Expanded(
                      child:pdfWidgets.Text(pietanze[index]['name'],style: pdfWidgets.TextStyle(font: font,fontSize: 14))
                  ),
                  pdfWidgets.Text("${pietanze[index]['costo']}€",style: pdfWidgets.TextStyle(font: font,fontSize: 14))
                ]
              );
            }),
          pdfWidgets.Row(
              children: [
                pdfWidgets.Text("$conto€",style: pdfWidgets.TextStyle(font: font,fontSize: 14)),
              ]
          )
          ]
        )
      );

    }
  ));

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/conto.pdf");
  await file.writeAsBytes(await pdf.save());
  }

}
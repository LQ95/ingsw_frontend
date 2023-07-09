import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;

class PdfControl{

  static createPdfConto(List<dynamic> pietanze, String tavoloId,double conto) async {
    String dataConto = DateTime.now().toLocal().toString();
    dataConto = convertDateFormat(dataConto);
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
            pdfWidgets.Text(dataConto,style: pdfWidgets.TextStyle(font: font,fontSize: 24)),
            pdfWidgets.ListView.builder(itemCount: pietanze.length,itemBuilder: (context,index){
              return
                pdfWidgets.Padding(
                  padding: pdfWidgets.EdgeInsets.symmetric(vertical: 16.0),
                child:pdfWidgets.Row(
                children: [
                  pdfWidgets.Expanded(
                      child:pdfWidgets.Text(pietanze[index]['name'],style: pdfWidgets.TextStyle(font: font,fontSize: 14))
                  ),
                  pdfWidgets.Text("${pietanze[index]['costo']}€",style: pdfWidgets.TextStyle(font: font,fontSize: 14))
                ]
              )
                );}),
          pdfWidgets.Padding(
              padding: pdfWidgets.EdgeInsets.symmetric(vertical: 16.0),
            child: pdfWidgets.Row(
              children: [
                pdfWidgets.Expanded(
                    child:pdfWidgets.Text("Totale:",style: pdfWidgets.TextStyle(font: font,fontSize: 14))
                ),
                pdfWidgets.Text("$conto€",style: pdfWidgets.TextStyle(font: font,fontSize: 14)),
              ]
          )
          )
          ]
        )
      );

    }
  ));
    String? output;
    if (Platform.isWindows) { //Se è wqindows apre la finestra per selezionare il file
      output = await FilePicker.platform.saveFile(
          dialogTitle: 'Seleziona dove salvare il conto:',
          fileName: 'Conto tavolo n°$tavoloId $dataConto.pdf',
          type: FileType.any);
    }
    else {
      output = await FilePicker.platform.getDirectoryPath() ;
    }
    if (output != null) {
      if(Platform.isAndroid) {
        output= "$output/conto.pdf";
      } else {
        output=output;
      }
      final file = File(output);
      print(output);
      await file.writeAsBytes(await pdf.save());
    }
  }

  static String convertDateFormat(String dataConto) {
    DateTime data = DateTime.parse(dataConto);
    DateFormat nuovoFormato = DateFormat('dd-MM-yyyy');
    String dataConvertita = nuovoFormato.format(data);
    return dataConvertita;
  }

}
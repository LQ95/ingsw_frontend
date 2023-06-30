import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;

class PdfControl{

  static createPdfConto(Map<String,dynamic> pietanze) async {
  final pdf= pdfWidgets.Document();
  pdf.addPage(pdfWidgets.Page(
    pageFormat: PdfPageFormat.a4,
    build: (pdfWidgets.Context context){
      //TODO effettivamente scrivere il codice della pagina
    }
  ));

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/conto.pdf");
  }

}
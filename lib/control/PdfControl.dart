import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;

class PdfControl{

  static createPdfConto(Map<String,dynamic> pietanze){
  final pdf= pdfWidgets.Document();
  pdf.addPage(pdfWidgets.Page(
    pageFormat: PdfPageFormat.a4,
    build: (pdfWidgets.Context context){
      //TODO effettivamente scrivere il codice della pagina
    }
  ));
  }

}
import 'dart:convert';
import 'dart:ffi';

import '../GlobImport.dart';
import 'package:http/http.dart' as http;

class OrdinazioneControl {

  Future<Map<String, dynamic>?> getCurrentOrdinazione(int tavolo) async {
    var apiUrl = Uri.http(baseUrl, "api/v1/ordinazione/getcurrent",
        {"tavoloId": tavolo.toString()});
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        Map<String, dynamic> ordinazione = jsonDecode(
            utf8.decode(response.bodyBytes));
        return ordinazione;
      } else {
        return null; // Gestione del caso in cui il corpo della risposta sia vuoto
      }
    } else {
      return null; // Gestione degli altri codici di stato HTTP diversi da 200
    }
  }


  Future<bool> closeCurrentOrdinazione(int tavolo) async {
    var apiUrl = Uri.http(
        baseUrl, "api/v1/ordinazione/closecurrent",
        {"tavoloId": tavolo.toString()});
    var response = await http.put(apiUrl);
    List<dynamic> ordinazione;

    if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  }

  Future<String> sendOrdinazioneToDb(int tavolo) async {
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/ordinazione'); //URL del punto di contatto della API
    var response = await http.post(apiUrl,
        //questa è la response,in cui è definita anche la request, direttamente
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'tavolo': tavolo.toString(),})
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode.toInt() == 200) {
      return "SUCCESSO";
    } else if (response.statusCode.toInt() == 500) {
      return "FALLIMENTO";
    }
    else {
      return "ERRORE INASPETTATO";
    }
  }

  Future<String> addPietanzaToOrdinazione(int ordinazioneId, int pietanzaId) async {
    var apiUrl = Uri.http(
      baseUrl,
      '/api/v1/ordinazione/addpietanza',
      {
        'pietanzaId': pietanzaId.toString(),
        'OrdinazId': ordinazioneId.toString(),
      },
    ); // URL del punto di contatto della API

    var response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode.toInt() == 200) {
      return "SUCCESSO";
    } else if (response.statusCode.toInt() == 500) {
      return "FALLIMENTO";
    } else {
      return "ERRORE INASPETTATO";
    }
  }

}
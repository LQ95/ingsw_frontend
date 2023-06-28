import 'dart:convert';

import '../GlobImport.dart';
import 'package:http/http.dart' as http;

class OrdinazioneControl {

  Future<List<dynamic>?> getCurrentOrdinazione(int tavolo) async {
    var apiUrl = Uri.http(baseUrl, "api/v1/ordinazione/getcurrent", {"tavoloId": tavolo.toString()});
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        List<dynamic> ordinazione = jsonDecode(utf8.decode(response.bodyBytes));
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
        baseUrl, "api/v1/ordinazione/closecurrent", {"tavoloId": tavolo.toString()});
    var response = await http.put(apiUrl);
    List<dynamic> ordinazione;

    if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  }

  Future<String> openNewOrdinazione(Map<String,String> pietanze)
  async {
    var apiUrl = Uri.http(baseUrl, "api/v1/ordinazione/opennew");
    var response = await http.post(apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pietanze)
    );
    if (response.statusCode == 200) {
      return "Successo";
    }
    else if (response.statusCode == 400){
      return "Già presente";
    }
    else return "Errore interno";

  }
}
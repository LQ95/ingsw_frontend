import 'dart:convert';
import 'package:http/http.dart' as http;

import '../GlobImport.dart';
import '../entity/Utente.dart';

class TavoloControl{

  Future<List?> getAllTavoliFromDB() async {   //Work in Progres
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/tavolo');
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // print(jsonResponse);
      return jsonResponse;
    }
    else {
      throw Exception('Errore inaspettato');
    }

  }

  Future<void> deleteTavoloFromDB() async {   //Work in Progres
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/tavolo/deleteHighest');
    var response = await http.delete(apiUrl);
  }

  Future<void> addTavoloToDB() async {
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/tavolo'); //URL del punto di contatto della API
    var response = await http.post(apiUrl,
        //questa è la response,in cui è definita anche la request, direttamente
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{})
    );
  }


}
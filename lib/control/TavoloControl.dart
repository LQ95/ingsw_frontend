import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ipConifig.dart';

class TavoloControl{

  Future<List?> getAllTavoliFromDB() async {
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/tavolo');
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // print(jsonResponse);
      return jsonResponse;
    }
    else {
      throw Exception('Errore di connessione');
    }

  }

  Future<void> deleteTavoloFromDB() async {
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/tavolo/deleteHighest');
    await http.delete(apiUrl);
  }

  Future<void> addTavoloToDB() async {
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/tavolo'); //URL del punto di contatto della API
    await http.post(apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{})
    );
  }


}
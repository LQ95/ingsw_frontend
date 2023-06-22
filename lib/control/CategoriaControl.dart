import 'dart:convert';
import 'package:http/http.dart' as http;

import '../GlobImport.dart';
import '../entity/Utente.dart';

class CategoriaControl {

  Future<List?> getAllCategorieFromDB() async {   //Work in Progres
    var apiUrl = Uri.http(baseUrl,
      '/api/v1/categoria');
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // print(jsonResponse);
      return jsonResponse;
    }
    else {
      return null;
    }

  }

  Future<String> deleteCategoriaFromDB(int id) async {   //Work in Progres
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/categoria/delete/$id');
    var response = await http.delete(apiUrl);
    if (response.statusCode == 200) {
      return "SUCCESSO";
    }
    else {
      return "FALLIMENTO";
    }

  }

  void addPietanzaToDB(int catId,int pietanzaId) async{
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/categoria/addpietanza'); //URL del punto di contatto della API
    var response = await http.put(apiUrl,
        //questa è la response,in cui è definita anche la request, direttamente
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'catId':catId,
          'pietanzaId':pietanzaId,
        }));
    print('Response status: ${response.statusCode}');
  }

  void deletePietanzaFromDB(int catId,int pietanzaId) async{
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/categoria/delpietanza'); //URL del punto di contatto della API
    var response = await http.put(apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'catId':catId,
          'pietanzaId':pietanzaId,
        }));
    print('Response status: ${response.statusCode}');
  }
}
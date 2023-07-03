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

  Future<bool> addPietanzaToDB(int catId,int pietanzaId) async{
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/categoria/addpietanza',{
          'catId':catId.toString(),
          'pietanzaId':pietanzaId.toString(),
        }); //URL del punto di contatto della API
    var response = await http.put(apiUrl,
        //questa è la response,in cui è definita anche la request, direttamente
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },);
    // print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> deletePietanzaFromDB(int catId, int pietanzaId) async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/categoria/delpietanza', {
      'pietanzaId': pietanzaId.toString(),
      'catId': catId.toString(),
    });

    var response = await http.delete(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return "SUCCESSO";
    } else {
      return "FALLIMENTO";
    }
  }

  Future<List?> getPietanzeFromCategoria(int idCategoria) async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/categoria/pietanze', {'catId': idCategoria.toString()});
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // Restituisci la lista di pietanze ottenuta dalla risposta
      return jsonResponse;
    } else {
      // In caso di errore, restituisci null o gestisci l'errore come desideri
      return null;
    }
  }

  Future<String> sendCategoriaToDb(String nome) async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/categoria');

    var response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nome': nome,
      }),
    );

    if (response.statusCode == 200) {
      return "SUCCESSO";
    } else if (response.statusCode == 500) {
      return "FALLIMENTO";
    } else {
      return "ERRORE INASPETTATO";
    }
  }



}
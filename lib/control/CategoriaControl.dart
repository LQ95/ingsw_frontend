import 'dart:convert';
import 'package:http/http.dart' as http;

import '../GlobImport.dart';
import '../entity/Utente.dart';

class CategoriaControl {
  Future<List?> getAllCategorieFromDB() async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/categoria');
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse;
    } else {
      throw Exception('Errore nella richiesta delle categorie');
    }
  }

  Future<void> deleteCategoriaFromDB(int id) async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/categoria/delete/$id');
    var response = await http.delete(apiUrl);
    if (response.statusCode != 200) {
      throw Exception('Errore durante l\'eliminazione della categoria');
    }
  }

  Future<void> addPietanzaToDB(int catId, int pietanzaId) async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/categoria/addpietanza', {
      'catId': catId.toString(),
      'pietanzaId': pietanzaId.toString(),
    });
    var response = await http.put(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Errore durante l\'aggiunta della pietanza alla categoria');
    }
  }

  Future<void> deletePietanzaFromDB(int catId, int pietanzaId) async {
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

    if (response.statusCode != 200) {
      throw Exception('Errore durante l\'eliminazione della pietanza dalla categoria');
    }
  }

  Future<List?> getPietanzeFromCategoria(int idCategoria) async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/categoria/pietanze', {'catId': idCategoria.toString()});
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse;
    } else {
      throw Exception('Errore nella richiesta delle pietanze dalla categoria');
    }
  }

  Future<void> sendCategoriaToDb(String nome) async {
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

    if (response.statusCode != 200) {
      throw Exception('Errore durante l\'invio della categoria al database');
    }
  }
}

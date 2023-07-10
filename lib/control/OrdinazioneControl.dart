import 'dart:convert';
import 'dart:ffi';

import '../GlobImport.dart';
import 'package:http/http.dart' as http;

class OrdinazioneControl {
  Future<Map<String, dynamic>?> getCurrentOrdinazione(int tavolo) async {
    var apiUrl = Uri.http(baseUrl, "api/v1/ordinazione/getcurrent", {"tavoloId": tavolo.toString()});
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        Map<String, dynamic> ordinazione = jsonDecode(utf8.decode(response.bodyBytes));
        return ordinazione;
      } else {
        return null;
      }
    } else {
        return null;
    }
  }

  Future<List?> getAllPietanzeFromOrdinazione(int idOrdinazione) async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/ordinazione/$idOrdinazione/pietanze');
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception("Codice di stato HTTP diverso da 200"); // Eccezione per codici di stato HTTP diversi da 200
    }
  }

  Future<void> closeCurrentOrdinazione(String tavolo) async {
    var apiUrl = Uri.http(baseUrl, "api/v1/ordinazione/closecurrent", {"tavoloId": tavolo.toString()});
    var response = await http.put(apiUrl);

    if (response.statusCode != 200) {
      throw Exception("Codice di stato HTTP diverso da 200"); // Eccezione per codici di stato HTTP diversi da 200
    }
  }

  Future<String> sendOrdinazioneToDb(int tavolo) async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/ordinazione');
    var response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tavolo': tavolo.toString(),
      }),
    );

    if (response.statusCode == 200) {
      return "SUCCESSO";
    } else if (response.statusCode == 500) {
      return "FALLIMENTO";
    } else {
      throw Exception("Errore inaspettato"); // Eccezione per altri codici di stato HTTP
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
    );

    var response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return "SUCCESSO";
    } else if (response.statusCode == 500) {
      throw Exception("Errore interno del server"); // Eccezione per codice di stato HTTP 500
    } else {
      throw Exception("Errore inaspettato"); // Eccezione per altri codici di stato HTTP
    }
  }
}

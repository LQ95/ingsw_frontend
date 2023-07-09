import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:isolate';
import 'package:http/http.dart' as http;

import '../GlobImport.dart';
import '../entity/Utente.dart';


//Classe di controllo che gestisce il salvataggio, la visualizzazione e l'eliminazione di pietanze sul db

class PietanzeControl{

  Future<List?> getAllPietanzeFromDB() async {   //Work in Progres
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/pietanza');
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // print(jsonResponse);
      return jsonResponse;
    }
    else {
      throw Exception("errore durante il recupero delle pietanze dal server");
    }

  }


  Future<String> deletePietanzaFromDB(int id) async {   //Work in Progres
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/pietanza/delete/$id');
    var response = await http.delete(apiUrl);
    if (response.statusCode == 200) {
      return "SUCCESSO";
    }
    else {
      throw Exception("errore durante la cancellazione della pietanza");
    }

  }


  Future<String> modificaPietanzainDB(int id, String name, String descrizione, String allergeni, String costo) async {
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/pietanza'); //URL del punto di contatto della API
    var response = await http.put(apiUrl,
        //questa è la response,in cui è definita anche la request, direttamente
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'descrizione': descrizione,
          'allergeni': allergeni,
          'costo': costo,
          'id': id.toString()
        })
    );

    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if(response.statusCode.toInt() == 200) {
      return "SUCCESSO";
    } else if(response.statusCode.toInt() == 500){
      throw Exception("errore interno del server");
    }
    else {
      throw Exception("errore inaspettato");
    }

  }


  Future<String> sendPietanzaToDb(String titolo, String descrizione, String allergeni, String costo) async{

    var apiUrl = Uri.http(baseUrl,
        '/api/v1/pietanza'); //URL del punto di contatto della API
    var response = await http.post(apiUrl,
        //questa è la response,in cui è definita anche la request, direttamente
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': titolo,
          'descrizione': descrizione,
          'allergeni' : allergeni,
          'costo' : costo})
    );

    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if(response.statusCode.toInt() == 200) {
      return "SUCCESSO";
    } else if(response.statusCode.toInt() == 500){
      throw Exception("errore interno del server");
    }
    else {
      throw Exception("errore inaspettato");
    }
  }


}
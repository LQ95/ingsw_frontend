import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:isolate';
import 'package:http/http.dart' as http;

import '../GlobImport.dart';
import '../entity/Utente.dart';

class MessaggiControl {
  Future<List?> getAllMessaggiFromDB() async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/Messaggio');
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse;
    } else {
      throw Exception('Errore nella richiesta dei messaggi');
    }
  }

  Future<void> sendMessaggioToDb(String mittente, String corpo) async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/Messaggio');
    var response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mittente': mittente,
        'corpo': corpo,
      }),
    );

    if (response.statusCode.toInt() != 200){
      throw Exception('Errore nell\'invio del messaggio');
    }
  }

  Future<void> setMessageAsRead(int id) async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/Messaggio/readupdate');
    var response = await http.put(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'messageId': id,
        'userId': Utente().getId,
      }),
    );

    if (response.statusCode == 200) {
      // La richiesta ha avuto successo
    } else {
      throw Exception('Errore nell\'aggiornamento del messaggio');
    }
  }


  static Future<Map<String, dynamic>> getUnreadMessagesList(Utente user) async {
    Map<String, dynamic> localList = Map<String, dynamic>();
    var response;
    var apiUrl = Uri.http(baseUrl, 'api/v1/Messaggio/unread', {
      'userId': user.getId.toString(),
      'username': user.getNome,
    });
    response = await http.get(apiUrl);

    if (response.statusCode == 200 ||response.statusCode == 204) {
      localList = jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      // In caso di errore 404, restituisci una lista vuota
      localList = {};
    } else {
      throw Exception('Errore nel recupero dei messaggi non letti');
    }

    return localList;
  }

}

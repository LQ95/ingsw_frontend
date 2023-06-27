import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:isolate';
import 'package:http/http.dart' as http;

import '../GlobImport.dart';
import '../entity/Utente.dart';


//Classe di controllo che gestisce l'invio, la recezione e la visualizzazione di notifiche e messaggi

class MessaggiControl{

  Future<List?> getAllMessaggiFromDB() async {   //Work in Progres
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/Messaggio');
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // print(jsonResponse[0]['mittente']);
      return jsonResponse;
    }
    else {
      return null;
    }

  }


  Future<String> sendMessaggioToDb(String mittente, String corpo) async{

    var apiUrl = Uri.http(baseUrl,
        '/api/v1/Messaggio'); //URL del punto di contatto della API
    var response = await http.post(apiUrl,
        //questa è la response,in cui è definita anche la request, direttamente
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'mittente': mittente,
          'corpo': corpo,})
    );

    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if(response.statusCode.toInt() == 200) {
      return "SUCCESSO";
    } else if(response.statusCode.toInt() == 500){
      return "FALLIMENTO";
    }
    else {
      return "ERRORE INASPETTATO";
    }
  }


  Future<String> setMessageAsRead(int id) async {
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/Messaggio/readupdate'); //URL del punto di contatto della API
    var response = await http.put(apiUrl,
        //questa è la response,in cui è definita anche la request, direttamente
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          'messageId':id,
          'userId':Utente().getId
        }));

    // print('Response status: ${response.statusCode}');
    if(response.statusCode.toInt() == 200) {
      return "SUCCESSO";
    } else if(response.statusCode.toInt() == 500){
      return "FALLIMENTO";
    }
    else {
      return "ERRORE INASPETTATO";
    }
  }

  static Future<Map<String, dynamic>> getUnreadMessagesList(Utente user) async {
    Map<String, dynamic> localList=Map<String, dynamic>();
    var response;
    // print("invio userId "+user.getId.toString());
    var apiUrl=Uri.http(baseUrl,'api/v1/Messaggio/unread',{'userId':user.getId.toString(),
      'username':user.getNome});
    response= await http.get(apiUrl);
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    if(response.statusCode.toInt() == 200) { //se riceve 200 i messaggi ci sono, riceve 404 se non ci sono
      localList= jsonDecode(response.body);
    }

    // print("lista messaggi non letti trovati dalla schermata dei messaggi:");
    // print(localList);


    return localList;

  }

}
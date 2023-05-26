import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseControl {
  Future<String> sendUserData(String name, String pass, String ruolo) async {
    var apiUrl = Uri.http('192.168.1.3:8080',
        '/api/v1/utente'); //URL del punto di contatto della API
    var response = await http.post(apiUrl,
        //questa è la response,in cui è definita anche la request, direttamente
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'nome': name,
          'password': pass,
          'ruolo': ruolo})
    );

    if(response.statusCode.toInt() == 200) {
      return "SUCCESSO";
    } else if(response.statusCode.toInt() == 500){
      return "FALLIMENTO";
    }
      else {
        return "ERRORE INASPETTATO";
    }
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
  }

  sendLoginData(String name, String pass) async{
    var apiUrl = Uri.http('192.168.1.3:8080',
        '/api/v1/utente'); //URL del punto di contatto della API
    var response = await http.post(apiUrl,
        //questa è la response,in cui è definita anche la request, direttamente
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'nome': name,
          'password': pass,
          })
    );

    if(response.statusCode.toInt() == 200) {
      return "SUCCESSO";
    } else if(response.statusCode.toInt() == 500){
      return "FALLIMENTO";
    }
    else {
      return "ERRORE INASPETTATO";
    }
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
  }

}
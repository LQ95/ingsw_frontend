import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseControl {
  final String baseUrl = '192.168.1.3:8080'; //Ip Marco  192.168.1.138:8080
  Future<String> sendUserData(String name, String pass, String ruolo) async {
    var apiUrl = Uri.http(baseUrl,
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

  sendLoginData(String name, String pass) async{ //Usa metodo GET
    var loginParameters = {
      'username': name,
      'password': pass,
    };

    var apiUrl = Uri.http(baseUrl,
        '/api/v1/utente/auth',loginParameters); //URL del punto di contatto della API,più udsername e pass come parametri
    var response = await http.get(apiUrl,
        //questa è la response,in cui è definita anche la request, direttamente
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('Response headers: ${response.headers}');
    String? ruolo = response.headers['ruolo'];
    if(response.statusCode.toInt() == 200) {
      return ruolo;
    } else if(response.statusCode.toInt() == 404){
      return "FALLIMENTO";
    }
    else {
      return "ERRORE INASPETTATO";
    }

  }

}
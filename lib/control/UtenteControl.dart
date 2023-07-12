import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:isolate';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:ingsw_frontend/control/ThreadControl.dart';
import 'MessaggiControl.dart';

import '../GlobImport.dart';
import '../entity/Utente.dart';


//Classe di controllo che gestisce gli accessi e le creazioni di nuovi utenti

class UtenteControl{

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

    //print('sendUserData Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if(response.statusCode.toInt() == 200) {
      return "SUCCESSO";
    } else if(response.statusCode.toInt() == 400){
      return "FALLIMENTO";}
    else {
      throw Exception("errore inaspettato");
    }

  }


  sendLoginData(String name, String pass) async{ //Usa metodo GET
    var User= Utente();
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
    //print('Response status: ${response.statusCode}');
    print('login Response headers: ${response.headers}');
    String? ruolo = response.headers['ruolo'];
    String? primoAccesso = response.headers['primo_accesso'];
    String? id = response.headers['id'];
    if(response.statusCode.toInt() == 200) {
      User.setRuolo=ruolo!;
      User.setId=int.parse(id!);
      User.setPrimoAccesso = primoAccesso!;
      User.setNome=name;
      //selectDrawer();
      ThreadControl TD = ThreadControl();
      //Manda la porta per comunicare all'isolate e la inizializza prima
      port= ReceivePort();
      await Isolate.spawn(TD.NotificationCheck,port.sendPort);
      //aspetto che l'isolate mi mandi la send port da cui inviargli i context che servono ogni volta ai popup
      outputFromIsolate= StreamQueue<dynamic>(port);
      sendPort = await outputFromIsolate.next;
      print("manda info utente");
      sendPort.send(User);
      if(primoAccesso == 'true')
      {
        return 'primoAccesso';
      }
      else
      {
        return ruolo;
      }
    } else if(response.statusCode.toInt() == 404){
      return "FALLIMENTO"; //questo è necessario
    }
    else {
      throw Exception("errore inaspettato del server");
    }

  }

  Future<void> updateUtenteData(String username,String newPassword,String ruolo,String id) async{
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/utente/firstupdate'); //URL del punto di contatto della API
    var response = await http.put(apiUrl,
        //questa è la response,in cui è definita anche la request, direttamente
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nome':username,
          'password': newPassword,
          'ruolo':ruolo,
          'id':id,
        }));
    Utente().setPrimoAccesso = "false";
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    // print('Response headers: ${response.headers}');
    if(response.statusCode.toInt() == 200) {

    } else if(response.statusCode.toInt() == 500){
      throw Exception("errore interno del server");
    }
    else {
      throw Exception("errore inaspettato");
    }
  }

  //La prossima classe controlla se il sistema è stato inizzato

  Future<int> isSistemInitialized() async {
    var apiUrl = Uri.http(baseUrl,
        '/api/v1/utente/init'); //URL del punto di contatto della API
    var response = await http.get(apiUrl);
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    if(response.statusCode.toInt() == 200) {
      return 0; //true
    } else if(response.statusCode.toInt() == 404){
      return 1; //false
    }
    else {
      throw Exception("errore inaspettato");
    }
  }



}
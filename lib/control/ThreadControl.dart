import 'dart:convert';
import 'dart:isolate';
import 'package:http/http.dart' as http;

import '../GlobImport.dart';
import '../entity/Utente.dart';

class ThreadControl{

  @pragma('vm:entry-point')
  Future<void> NotificationCheck(SendPort p) async { //TODO capire come killare sto thread al logout
    print("entro nell'isolate");
    final communicationPort=ReceivePort();
    p.send(communicationPort.sendPort); //l'isolate va spawnato passandogli direttamente una sendport
    Map<String, dynamic> localList=Map<String, dynamic>();
    Map<String, dynamic> newList=Map<String, dynamic>();
    bool popupWasFlashed=false;
    Utente usr=Utente();

    // print("utente:"+user.toString());

    await for (final message in communicationPort) {
      if (message is Utente) {
        print("ricevo utente");
        usr = message;
        // Send the result to the main isolate.
      }
      else if (message is String) {
        await Future.delayed(const Duration(seconds: 1));
        print("entra nel loop");
        print("il thread ha ricevuto una stringa");
        newList= await findUnreadMessages(usr);
        popupWasFlashed=!areThereNewMessages(localList,newList);
        if(!popupWasFlashed)
        {
          //TODO la funzione per fare la notifica
          print("apro il popup");
          p.send(true); //attiva flag per mostrare il popup
          popupWasFlashed=true;
        }
        localList.clear();
        localList.addAll(newList);
        // Send the result to the main isolate.
      } else if (message == null) {
        //TODO completare la logica e capire tuti i casi possibili
        break;
      }
    }
    print("stampo utente");
    print(usr);

    print("thread notifiche finito.è stato effettuato il logout?");
    Isolate.exit();

  }

  static bool areThereNewMessages(Map<String, dynamic> localList, Map<String, dynamic> globalList) {
    bool newMessages=false;
    int i;
    String key;
    // print("verifico se ci sono messaggi nuovi");
    if(globalList.length<=localList.length) {
      for (i = 0; i < globalList.length /
          3; i++) { //divido per 3 perchè ogni messaggio ha 3 campi ma ce ne serve solo 1
        key = "id$i"; //interpolazione, produce una stringa tipo "id0","id1" ecc
        if (localList[key] != globalList[key]) {
          // print("ci sono messaggi nuovi");
          newMessages = true;
          break;
        }
      }
    } else {
      // print("ci sono messaggi nuovi, causa lunghezza lista");
      newMessages=true; //se la lista nuova ha messaggi in più ovviamente è stata aggiornata.
    }

    return newMessages; //se la lsista è stat aggiornata il popup dev essere riflashato, quindi il flag deve essere false, e viceversa.
  }


  static Future<Map<String, dynamic>> findUnreadMessages(Utente user) async {
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

    // print("lista mess non letti su thread:");
    // print(localList);


    return localList;

  }



}
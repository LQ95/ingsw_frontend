import 'dart:convert';
import 'package:http/http.dart' as http;

import '../GlobImport.dart';
import '../entity/Utente.dart';

class ThreadControl{

  @pragma('vm:entry-point')
  Future<void> NotificationCheck(Utente user) async { //TODO capire come killare sto thread al logout

    bool popupWasFlashed=false;
    // print("utente:"+user.toString());
    while(user.getNome != ""){
      await Future.delayed(const Duration(seconds: 1));
      // print("entra nel loop");

      popupWasFlashed= await findUnreadMessages();

      if(!popupWasFlashed)
      {
        //TODO la funzione per fare la notifica
        print("apro il popup");
        popupWasFlashed=true;
      }
      else{


      }
    }
    print("thread notifiche finito.è stato effettuato il logout?");

  }

  static bool areThereNewMessages(Map<String, dynamic> localList, Map<String, dynamic> globalList) {
    bool newMessages=false;
    int i;
    String key;
    print("verifico se ci sono messaggi nuovi");
    if(globalList.length<=localList.length) {
      for (i = 0; i < globalList.length /
          3; i++) { //divido per 3 perchè ogni messaggio ha 3 campi ma ce ne serve solo 1
        key = "id$i"; //interpolazione, produce una stringa tipo "id0","id1" ecc
        if (localList[key] != globalList[key]) {
          print("ci sono messaggi nuovi");
          newMessages = true;
          break;
        }
      }
    } else {
      print("ci sono messaggi nuovi, causa lunghezza lista");
      newMessages=true; //se la lista nuova ha messaggi in più ovviamente è stata aggiornata.
    }

    return newMessages; //se la lsista è stat aggiornata il popup dev essere riflashato, quindi il flag deve essere false, e viceversa.
  }


  static Future<bool> findUnreadMessages() async {
    Map<String, dynamic> localList=Map<String, dynamic>();
    localList.addAll(globalUnreadMessages);
    bool newMessages=false;
    var response;
    var apiUrl=Uri.http(baseUrl,'api/v1/Messaggio/unread',{'userId':Utente().getId.toString(),
      'username':Utente().getNome});
    response= await http.get(apiUrl);
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    if(response.statusCode.toInt() == 200) { //se riceve 200 i messaggi ci sono, riceve 404 se non ci sono
      globalUnreadMessages= jsonDecode(response.body);
    }

    //print("lista locale:");
    //print(localList);
    //print("lista globale messaggi non letti trovati:");
    //print(globalUnreadMessages);

    newMessages = !areThereNewMessages(localList,globalUnreadMessages);
    return newMessages;

  }

}
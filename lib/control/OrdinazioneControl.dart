import 'dart:convert';

import '../GlobImport.dart';
import 'package:http/http.dart' as http;

class OrdinazioneControl{
  Future<List?> getCurrentOrdinazione(int tavolo) async {
  var apiUrl=Uri.http(baseUrl,"api/v1/ordinazione/getcurrent",{"tavoloId":tavolo});
  var response=await http.get(apiUrl);
  List<dynamic> ordinazione;

  if (response.statusCode == 200) {
    ordinazione= jsonDecode(utf8.decode(response.bodyBytes));
    print(ordinazione);
    return ordinazione;
  }
  else {
    return null;
  }


  }

  Future<bool> closeCurrentOrdinazione(int tavolo) async {
    var apiUrl=Uri.http(baseUrl,"api/v1/ordinazione/closecurrent",{"tavoloId":tavolo});
    var response=await http.get(apiUrl);
    List<dynamic> ordinazione;

    if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }

}
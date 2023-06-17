import 'dart:convert';
import 'package:http/http.dart' as http;

import '../GlobImport.dart';
import '../entity/Utente.dart';

class CategoriaControl {

  Future<List?> getAllCategorieFromDB() async {   //Work in Progres
    var apiUrl = Uri.http(baseUrl,
      '/api/v1/categoria');
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // print(jsonResponse);
      return jsonResponse;
    }
    else {
      return null;
    }

  }
}
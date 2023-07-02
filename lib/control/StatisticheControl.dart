import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../GlobImport.dart';
import '../entity/Utente.dart';


class StatisticheControl {

  Future<Map<DateTime, double>> getClosedOrdinazioniFromDB() async {
    var apiUrl = Uri.http('localhost:8080', '/api/v1/ordinazione/statistiche-ordinazioni-chiuse');
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonBody = utf8.decode(response.bodyBytes);
      var jsonResponse = jsonDecode(jsonBody);

      Map<DateTime, double> res = {};
      jsonResponse.forEach((dateString, prices) {
        var date = DateTime.parse(dateString);
        var pricesList = (prices as List<dynamic>).map((price) => price.toDouble()).toList();
        var totalPrice = pricesList.reduce((value, element) => value + element);
        res[date] = totalPrice;
      });

      print(res);

      return res;
    } else {
      throw Exception('Failed to retrieve closed ordinazioni');
    }
  }
}
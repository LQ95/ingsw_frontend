import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../GlobImport.dart';
import '../entity/OrdinazioneData.dart';
import '../entity/Utente.dart';


class StatisticheControl {

  Future<List<OrdinazioneData>> getGuadagniTotaliFromDB() async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/ordinazione/statistiche-ordinazioni-chiuse');
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonBody = utf8.decode(response.bodyBytes);
      var jsonResponse = jsonDecode(jsonBody);

      Map<DateTime, double> stats = {};
      jsonResponse.forEach((dateString, prices) {
        var date = DateTime.parse(dateString);
        var pricesList = (prices as List<dynamic>).map((price) => price.toDouble()).toList();
        var totalPrice = pricesList.reduce((value, element) => value + element);
        stats[date] = totalPrice;
      });

      // Somma i valori dei conti di ordinazioni con la stessa data
      Map<DateTime, double> aggregatedStats = {};
      for (var entry in stats.entries) {
        DateTime date = entry.key;
        double price = entry.value;

        if (aggregatedStats.containsKey(date)) {
          aggregatedStats[date] = aggregatedStats[date]! + price;
        } else {
          aggregatedStats[date] = price;
        }
      }

      // Ordina le date in ordine crescente
      List<DateTime> sortedDates = aggregatedStats.keys.toList()
        ..sort((a, b) => a.compareTo(b));

      // Crea una lista ordinata di dati per il grafico
      List<OrdinazioneData> data = sortedDates.map((date) {
        return OrdinazioneData(date, aggregatedStats[date]!);
      }).toList();

      return data;
    } else {
      throw Exception('Failed to retrieve closed ordinazioni');
    }
  }

  Future<List<OrdinazioneData>> getGuadagniInDateFromDB(DateTime dataInizio, DateTime dataFine) async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/ordinazione/statistiche-ordinazioni-by-date', {
      'dataInizio': DateFormat('yyyy-MM-dd').format(dataInizio),
      'dataFine': DateFormat('yyyy-MM-dd').format(dataFine),
    });

    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonBody = utf8.decode(response.bodyBytes);
      var jsonResponse = jsonDecode(jsonBody);

      Map<DateTime, double> stats = {};
      jsonResponse.forEach((dateString, prices) {
        var date = DateTime.parse(dateString);
        var pricesList = (prices as List<dynamic>).map((price) => price.toDouble()).toList();
        var totalPrice = pricesList.reduce((value, element) => value + element);
        stats[date] = totalPrice;
      });

      // Somma i valori dei conti di ordinazioni con la stessa data
      Map<DateTime, double> aggregatedStats = {};
      for (var entry in stats.entries) {
        DateTime date = entry.key;
        double price = entry.value;

        if (aggregatedStats.containsKey(date)) {
          aggregatedStats[date] = aggregatedStats[date]! + price;
        } else {
          aggregatedStats[date] = price;
        }
      }

      // Ordina le date in ordine crescente
      List<DateTime> sortedDates = aggregatedStats.keys.toList()
        ..sort((a, b) => a.compareTo(b));

      // Crea una lista ordinata di dati per il grafico
      List<OrdinazioneData> data = sortedDates.map((date) {
        return OrdinazioneData(date, aggregatedStats[date]!);
      }).toList();

      return data;
    } else {
      throw Exception('Failed to retrieve closed ordinazioni');
    }
  }



}
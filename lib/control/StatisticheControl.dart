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

  Future<List<OrdinazioneData>> _getGuadagniTotaliFromDB() async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/ordinazione/statistiche-ordinazioni-chiuse');
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonBody = utf8.decode(response.bodyBytes);
      var jsonResponse = jsonDecode(jsonBody);

      Map<DateTime, List<double>> stats = {};
      jsonResponse.forEach((dateString, prices) {
        var date = DateTime.parse(dateString);
        var pricesList = (prices as List<dynamic>).cast<double>();
        stats[date] = pricesList;
      });

      // Calcola il numero totale dei conti per ogni data
      Map<DateTime, int> numeroContiMap = {};
      stats.forEach((date, pricesList) {
        numeroContiMap[date] = pricesList.length;
      });

      // Somma i prezzi dei conti per ogni data
      Map<DateTime, double> aggregatedStats = {};
      stats.forEach((date, pricesList) {
        var totalPrice = pricesList.reduce((value, element) => value + element);
        aggregatedStats[date] = totalPrice;
      });

      // Ordina le date in ordine crescente
      List<DateTime> sortedDates = aggregatedStats.keys.toList()
        ..sort((a, b) => a.compareTo(b));

      // Crea una lista ordinata di dati per il grafico
      List<OrdinazioneData> data = sortedDates.map((date) {
        var price = aggregatedStats[date]!;
        var numeroConti = numeroContiMap[date]!;
        var mediaGiornaliera = price / numeroConti;
        return OrdinazioneData(date, price, numeroConti: numeroConti, mediaGiornaliera: mediaGiornaliera);
      }).toList();

      return data;
    } else {
      throw Exception('Failed to retrieve closed ordinazioni');
    }
  }




  Future<List<OrdinazioneData>> _getGuadagniInDateFromDB(DateTime dataInizio, DateTime dataFine) async {
    var apiUrl = Uri.http(baseUrl, '/api/v1/ordinazione/statistiche-ordinazioni-by-date', {
      'dataInizio': DateFormat('yyyy-MM-dd').format(dataInizio),
      'dataFine': DateFormat('yyyy-MM-dd').format(dataFine),
    });

    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonBody = utf8.decode(response.bodyBytes);
      var jsonResponse = jsonDecode(jsonBody);

      Map<DateTime, List<double>> stats = {};
      jsonResponse.forEach((dateString, prices) {
        var date = DateTime.parse(dateString);
        var pricesList = (prices as List<dynamic>).cast<double>(); // Aggiunta del cast
        stats[date] = pricesList;
      });

      // Calcola il numero totale dei conti per ogni data
      Map<DateTime, int> numeroContiMap = {};
      stats.forEach((date, pricesList) {
        numeroContiMap[date] = pricesList.length;
      });

      // Somma i prezzi dei conti per ogni data
      Map<DateTime, double> aggregatedStats = {};
      stats.forEach((date, pricesList) {
        var totalPrice = pricesList.reduce((value, element) => value + element);
        aggregatedStats[date] = totalPrice;
      });

      // Ordina le date in ordine crescente
      List<DateTime> sortedDates = aggregatedStats.keys.toList()
        ..sort((a, b) => a.compareTo(b));

      // Crea una lista ordinata di dati per il grafico
      List<OrdinazioneData> data = sortedDates.map((date) {
        var price = aggregatedStats[date]!;
        var numeroConti = numeroContiMap[date]!;
        var mediaGiornaliera = price / numeroConti;
        return OrdinazioneData(date, price, numeroConti: numeroConti, mediaGiornaliera: mediaGiornaliera);
      }).toList();

      return data;
    } else {
      throw Exception('Failed to retrieve closed ordinazioni');
    }
  }


  Future<List<OrdinazioneData>> getStatistiche({DateTime? dataInizio, DateTime? dataFine}) async {
    List<OrdinazioneData> stats = [];
    if (dataInizio != null && dataFine != null) {
      return _getGuadagniInDateFromDB(dataInizio, dataFine);
    } else {
      return _getGuadagniTotaliFromDB();
    }
  }


}
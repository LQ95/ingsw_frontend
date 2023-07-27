import 'package:flutter_test/flutter_test.dart';
import 'package:ingsw_frontend/control/PietanzeControl.dart';


void main() {

  //Test sendPietanzaToDb
  group('PietanzeControl - sendPietanzaToDb', () {
    test('Test con parametri validi', () async {
      PietanzeControl control = PietanzeControl();
      String titolo = 'Pizza Margherita';
      String descrizione = 'Una deliziosa pizza con pomodoro e mozzarella';
      String allergeni = 'Glutine, lattosio';
      String costo = '8.50';

      // Eseguo la funzione con parametri validi
      expect(
            () => control.sendPietanzaToDb(titolo, descrizione, allergeni, costo),
        returnsNormally,
      );
    });

    test('Test con tutti i parametri vuoti', () async {
      PietanzeControl control = PietanzeControl();
      String titolo = "";
      String descrizione = "";
      String allergeni = "";
      String costo = "";

      // Eseguo la funzione con tutti i parametri vuoti
      expect(
            () => control.sendPietanzaToDb(titolo, descrizione, allergeni, costo),
        throwsA(isA<Exception>()),
      );
    });

    test('Test con i parametri opzionali vuoti', () async {
      PietanzeControl control = PietanzeControl();
      String titolo = "Pasta al forno";
      String descrizione = "";
      String allergeni = "";
      String costo = "12.50";

      // Eseguo la funzione con tutti i parametri null
      expect(
            () => control.sendPietanzaToDb(titolo, descrizione, allergeni, costo),
        returnsNormally,
      );
    });
  });
}

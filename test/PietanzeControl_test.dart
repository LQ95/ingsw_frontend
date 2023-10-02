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

      // Eseguo la funzione con tutti i opzionali parametri null
      expect(
            () => control.sendPietanzaToDb(titolo, descrizione, allergeni, costo),
        returnsNormally,
      );
    });

    test('Test con titolo vuoto e altri parametri validi', () async {
      PietanzeControl control = PietanzeControl();
      String titolo = "";
      String descrizione = "Deliziosa pasta al pesto";
      String allergeni = "Frutta a guscio";
      String costo = "10.00";

      // Eseguo la funzione con titolo vuoto e altri parametri validi
      expect(
            () => control.sendPietanzaToDb(titolo, descrizione, allergeni, costo),
        throwsA(isA<Exception>()),
      );
    });

    test('Test con costo vuoto e altri parametri validi', () async {
      PietanzeControl control = PietanzeControl();
      String titolo = "Lasagna";
      String descrizione = "Deliziosa lasagna al forno";
      String allergeni = "";
      String costo = "";

      // Eseguo la funzione con costo vuoto e altri parametri validi
      expect(
            () => control.sendPietanzaToDb(titolo, descrizione, allergeni, costo),
        throwsA(isA<Exception>()),
      );
    });

    test('Test con parametri validi, ma con il costo = 0', () async {
      PietanzeControl control = PietanzeControl();
      String titolo = 'Pizza Americana';
      String descrizione = 'Una deliziosa pizza con patatine e wurstel';
      String allergeni = 'Glutine, lattosio';
      String costo = '0';

      // Eseguo la funzione con parametri validi, ma con un costo di 0
      expect(
            () => control.sendPietanzaToDb(titolo, descrizione, allergeni, costo),
        throwsA(isA<Exception>()),
      );
    });

    test('Test con parametri validi, ma con il costo < 0', () async {
      PietanzeControl control = PietanzeControl();
      String titolo = 'Pizza Mimosa';
      String descrizione = 'Una deliziosa pizza con panna, prosciutto e mais';
      String allergeni = 'Glutine, lattosio';
      String costo = '-12.50';

      // Eseguo la funzione con parametri validi, ma con un costo di <0
      expect(
            () => control.sendPietanzaToDb(titolo, descrizione, allergeni, costo),
        throwsA(isA<Exception>()),
      );
    });

    test('Test con parametri validi, ma con il costo è una stringa non composta da numeri', () async {
      PietanzeControl control = PietanzeControl();
      String titolo = 'Pizza Focaccia';
      String descrizione = 'Una semplice pizza con origano';
      String allergeni = 'Glutine';
      String costo = 'Errore';

      // Eseguo la funzione con parametri validi, ma con un costo inserito come se fosse una stringa non numerica
      expect(
            () => control.sendPietanzaToDb(titolo, descrizione, allergeni, costo),
        throwsA(isA<Exception>()),
      );
    });
  });


  //Flow control

  group('PietanzeControl - sendPietanzaToDb - Flow Test', (){

    test('test path: Inizio -> 1 -> 2 -> 3 -> Fine', () async {
      PietanzeControl control = PietanzeControl();
      String titolo = 'Risotto al nero di seppia';
      String descrizione = 'Complesso piatto cucinato con il nero di seppia';
      String allergeni = '';
      String costo = '18.50';

      // Eseguire la funzione e attendere il completamento senza errori
      await expectLater(
        control.sendPietanzaToDb(titolo, descrizione, allergeni, costo),
        completes, // La funzione si completa senza errori
      );
    });

    test('test path: Inizio -> 1 -> 2 -> 3 -> 4 -> Fine (con eccezione)', () async {
      PietanzeControl control = PietanzeControl();
      String titolo = 'Risotto al nero di seppia';
      String descrizione = 'Complesso piatto cucinato con il nero di seppia';
      String allergeni = '';
      String costo = '18.50';

      await expectLater(
        control.sendPietanzaToDb(titolo, descrizione, allergeni, costo),
        throwsA(isA<Exception>()), // Aspettati un'eccezione di tipo Exception
      );
    });
  });
}

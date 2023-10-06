
import 'package:Ratatouille23/control/UtenteControl.dart';
import 'package:Ratatouille23/entity/Utente.dart';
import 'package:test/test.dart';


void main() {
  UtenteControl utenteControl = UtenteControl();
  Utente utente = Utente();

  //Inizializzazione utenti
  group('UtenteControl - sendUserData', ()
  {

    test('Test sendUserData con parametri corretti', () async {
      String result = await utenteControl.sendUserData('John', 'pass123', 'AMMINISTRATORE');
      expect(result, equals("SUCCESSO"));
    });

    test('Test sendUserData con parametri corretti, ma con caratteri speciali nel nome', () async {
      String result = await utenteControl.sendUserData('John@!32', 'pass123', 'AMMINISTRATORE');
      expect(result, equals("SUCCESSO"));
    });

    test('Test sendUserData con parametri corretti, ma con caratteri speciali nella password', () async {
      String result = await utenteControl.sendUserData('Ernesto', 'pass123@!!?', 'AMMINISTRATORE');
      expect(result, equals("SUCCESSO"));
    });

    test('Test sendUserData con parametri corretti n°2 (e password già esistente)', () async {
      String result = await utenteControl.sendUserData('Piero', 'pass123', 'SUPERVISORE');
      expect(result, equals("SUCCESSO"));
    });

    test('Test sendUserData con parametri corretti, ma già utilizzati', () async {
      String result = await utenteControl.sendUserData('John', 'pass123', 'AMMINISTRATORE');
      expect(result, equals("FALLIMENTO"));
    });

    test('Test sendUserData con parametri corretti, ma nome utente già scelto', () async {
      String result = await utenteControl.sendUserData('John', 'noooo', 'SUPERVISORE');
      expect(result, equals("FALLIMENTO"));
    });

    test('Test sendUserData parametri corretti, ma ruolo inesistente', () async {
      String result = await utenteControl.sendUserData('Carlo', 'pass123', 'InvalidRole');
      expect(result, equals("FALLIMENTO"));
    });

    test('Test sendUserData parametri vuoti', () async {
      String result = await utenteControl.sendUserData('', '', '');
      expect(result, equals("FALLIMENTO"));
    });

    test('Test sendUserData nome vuoto (Parametro not empty, si aspetta eccezione)', () async {
      expect(() async => await utenteControl.sendUserData('', 'pass', 'SUPERVISORE'),
          throwsA(isA<Exception>())
      );
    });

    test('Test sendUserData pass vuota (Parametro not empty, si aspetta eccezione)', () async {
      expect(() async => await utenteControl.sendUserData('Lucas', '', 'SUPERVISORE'),
          throwsA(isA<Exception>())
      );
    });

    test('Test sendUserData ruolo vuoto (Parametro not null, non si aspetta eccezione, ma l\'operazione non deve essere completata)', () async {
      String result = await utenteControl.sendUserData('Piero', 'pass', '');
      expect(result, equals("FALLIMENTO"));
    });

  });

  //Flow control sendUserData

  group('Utente - sendUserData - Flow Test', (){

    test('test path: Inizio -> 1 -> 2 -> 3 -> 4 -> Fine', () {
      // Eseguire la funzione e attendere il completamento senza errori e con il risultato "SUCCESSO"
      expect(
        utenteControl.sendUserData('Luigi', 'pass', 'CUCINA'),
        completion(equals("SUCCESSO")),
      );
    });


    test('test path: Inizio -> 1 -> 2 -> 3 -> 5 -> Fine', () {
      // Eseguire la funzione e attendere il completamento senza errori e con il risultato "FALLIMENTO"
      expect(
        utenteControl.sendUserData('Luigi', 'pass', 'CUCINA'),
        completion(equals("FALLIMENTO")),
      );
    });


    test('test path: Inizio -> 1 -> 2 -> 3 -> 6 ->Fine', () async {

      // Eseguire la funzione e attendere il completamento senza errori, ma con return FALLIMENTO
      await expectLater(
        utenteControl.sendUserData('', '', 'CUCINA'),  //Nome già inserito
        throwsA(isA<Exception>()),
      );
    });

  });

  //Test sui login
  group('UtenteControl - sendLoginData', () {

    test('Test sendLoginData, primo accesso di un utente', () async {
      String result = await utenteControl.sendLoginData('John', 'pass123');
      expect(result, equals("primoAccesso"));
    });

    test('Test sendLoginData con dati errati', () async {
      String result = await utenteControl.sendLoginData('Errore', 'Inesistente');
      expect(result, equals("FALLIMENTO"));
    });

    test('Test sendLoginData con dati vuoti', () async {
      String result = await utenteControl.sendLoginData('', '');
      expect(result, equals("FALLIMENTO"));
    });

    test('Test sendLoginData con dati esatti, su un utente che non è al primo accesso di tipo amministratore', () async {
      String result = await utenteControl.sendLoginData('a', 'a'); //Nota bene, l'utente a a è un utente creato appositamente per il testing nel database, non sto provando ad accere nuovamente all'utente creato ora "Jhon", in quanto il valore "primoAccesso" viene impostato a false solo dopo un corretto cambio di password
      expect(result, equals("AMMINISTRATORE"));
    });

    test('Test sendLoginData con dati esatti, su un utente che non è al primo accesso di tipo sala', () async {
      String result = await utenteControl.sendLoginData('b', 'b'); //Vedi commento sopra
      expect(result, equals("SALA"));
    });


  });

  //Flow control sendLoginData

  group('Utente - sendLoginData - Flow Test', (){

    test('test path: Inizio -> 1 -> 2 -> 3 -> 4 -> 8 -> Fine', () {
      // Eseguire la funzione e attendere il completamento senza errori e con il risultato "primoAccesso"
      expect(
        utenteControl.sendLoginData('Luigi', 'pass'),
        completion(equals("primoAccesso")),
      );
    });

    test('test path: Inizio -> 1 -> 2 -> 3 -> 4 -> 7 -> Fine', () {
      // Eseguire la funzione e attendere il completamento senza errori e con il risultato "SALA"
      expect(
        utenteControl.sendLoginData('b', 'b'),
        completion(equals("SALA")),
      );
    });


    test('test path: Inizio -> 1 -> 2 -> 3 -> 5 -> Fine', () {
      // Eseguire la funzione e attendere il completamento senza errori e con il risultato "FALLIMENTO"
      expect(
        utenteControl.sendLoginData('non', 'esiste'),
        completion(equals("FALLIMENTO")),
      );
    });
  });


}

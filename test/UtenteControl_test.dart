import 'package:ingsw_frontend/control/OrdinazioneControl.dart';
import 'package:ingsw_frontend/entity/Utente.dart';
import 'package:test/test.dart';
import 'package:ingsw_frontend/control/UtenteControl.dart';


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

    test('Test sendLoginData con dati esatti, su un utente che non è al primo accesso di tipo amministratore', () async {
      String result = await utenteControl.sendLoginData('b', 'b'); //Vedi commento sopra
      expect(result, equals("SALA"));
    });


  });
}

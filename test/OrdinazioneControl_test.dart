import 'package:ingsw_frontend/control/OrdinazioneControl.dart';
import 'package:test/test.dart';

void main() {
  var ordinazioneControl = OrdinazioneControl();

  group('OrdinazioneControl - addPietanzaToOrdinazione', ()
  {

    //Aggiungere pietanza esistente in ordinazione aperta
    test('Aggiunta pietanza all\'ordinazione 1 (l\'ordinazione è aperta di default nel db attuale', () async {
      // Crea un'istanza della classe OrdinazioneControl

      // Prova ad aggiungere la pietanza con id 1 all'ordinazione aperta con id 1
      expect(() async =>
      await ordinazioneControl.addPietanzaToOrdinazione(1, 1), returnsNormally);
    });


    //Aggiungere pietanza inesistente in ordinazione aperta
    test('Aggiunta pietanza inesistente all\'ordinazione 1 (l\'ordinazione è aperta di default nel db attuale', () async {
      // Crea un'istanza della classe OrdinazioneControl

      // Prova ad aggiungere la pietanza con id inesistente all'ordinazione aperta con id 1
      expect(() async =>
      await ordinazioneControl.addPietanzaToOrdinazione(1, 999999), throwsA(isA<Exception>()));
    });

    //Aggiungere pietanza esistente in ordinazione chiusa
    test('Aggiunta pietanza esistente all\'ordinazione 1 (l\'ordinazione è chiusa di default nel db attuale', () async {
      // Crea un'istanza della classe OrdinazioneControl

      // Prova ad aggiungere la pietanza con id 1 all'ordinazione chiusa con id 2
      expect(() async => await ordinazioneControl.addPietanzaToOrdinazione(2, 1), throwsA(isA<Exception>()));
    });

    //Aggiungere pietanza esistente in ordinazione inesistente
    test('Aggiunta pietanza inesistente all\'ordinazione 1 (l\'ordinazione è chiusa di default nel db attuale', () async {
      // Crea un'istanza della classe OrdinazioneControl

      // Prova ad aggiungere la pietanza con id 1 all'ordinazione inesistente con id 999999
      expect(() async => await ordinazioneControl.addPietanzaToOrdinazione(999999, 1), throwsA(isA<Exception>()));
    });

    //Aggiungere pietanza con id < 1 ad un'ordinazione con id < 1
    test('Aggiunta pietanza all\'ordinazione 1 (l\'ordinazione è aperta di default nel db attuale', () async {
      // Crea un'istanza della classe OrdinazioneControl

      // Prova ad aggiungere la pietanza con id -12 all'ordinazione inesistente con id -21
      expect(() async =>
      await ordinazioneControl.addPietanzaToOrdinazione(-21, -12), throwsA(isA<Exception>()));
    });

    //Aggiungere pietanza esistente in ordinazione con id < 1
    test('Aggiunta pietanza all\'ordinazione 1 (l\'ordinazione è aperta di default nel db attuale', () async {
      // Crea un'istanza della classe OrdinazioneControl

      // Prova ad aggiungere la pietanza con id 1 all'ordinazione inesistente con id -21
      expect(() async =>
      await ordinazioneControl.addPietanzaToOrdinazione(-21, 1), throwsA(isA<Exception>()));
    });

    //Aggiungere pietanza con id <1 in ordinazione esistente ed aperta
    test('Aggiunta pietanza all\'ordinazione 1 (l\'ordinazione è aperta di default nel db attuale', () async {
      // Crea un'istanza della classe OrdinazioneControl

      // Prova ad aggiungere la pietanza con id -1 all'ordinazione aperta con id 1
      expect(() async =>
      await ordinazioneControl.addPietanzaToOrdinazione(1, -1), throwsA(isA<Exception>()));
    });

  });


  //Flow control

  group('Ordinazione - addPietanzaToOrdinazione - Flow Test', (){

    test('test path: Inizio -> 1 -> 2 -> 3 -> Fine', () async {

      // Eseguire la funzione e attendere il completamento senza errori
      await expectLater(
        ordinazioneControl.addPietanzaToOrdinazione(1, 1),
        completes, // La funzione si completa senza errori
      );
    });


    test('test path: Inizio -> 1 -> 2 -> 3 -> 4 -> Fine', () async {

      // Eseguire la funzione e attendere l'eccezione sollevata
      var error;
      try {
        await ordinazioneControl.addPietanzaToOrdinazione(2, 1);
      } catch (e) {
        error = e;
      }

      // Verifica il tipo dell'eccezione
      expect(error, isA<Exception>());

      // Verifica il messaggio specifico dell'eccezione
      expect(error.toString(), equals("Exception: Errore interno del server"));
    });

  });

}

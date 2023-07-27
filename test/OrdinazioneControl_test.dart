import 'package:ingsw_frontend/control/OrdinazioneControl.dart';
import 'package:test/test.dart';

void main() {
  group('OrdinazioneControl - addPietanzaToOrdinazione', ()
  {

    //Aggiungere pietanza esistente in ordinazione aperta
    test('Aggiunta pietanza all\'ordinazione 1 (l\'ordinazione è aperta di default nel db attuale', () async {
      // Crea un'istanza della classe OrdinazioneControl
      var ordinazioneControl = OrdinazioneControl();

      // Prova ad aggiungere la pietanza con id 1 all'ordinazione aperta con id 1
      expect(() async =>
      await ordinazioneControl.addPietanzaToOrdinazione(1, 1), returnsNormally);
    });


    //Aggiungere pietanza inesistente in ordinazione aperta
    test('Aggiunta pietanza inesistente all\'ordinazione 1 (l\'ordinazione è aperta di default nel db attuale', () async {
      // Crea un'istanza della classe OrdinazioneControl
      var ordinazioneControl = OrdinazioneControl();

      // Prova ad aggiungere la pietanza con id inesistente all'ordinazione aperta con id 1
      expect(() async =>
      await ordinazioneControl.addPietanzaToOrdinazione(1, 999999), throwsA(isA<Exception>()));
    });

    //Aggiungere pietanza esistente in ordinazione chiusa
    test('Aggiunta pietanza inesistente all\'ordinazione 1 (l\'ordinazione è chiusa di default nel db attuale', () async {
      // Crea un'istanza della classe OrdinazioneControl
      var ordinazioneControl = OrdinazioneControl();

      // Prova ad aggiungere la pietanza con id 1 all'ordinazione chiusa con id 2
      expect(() async => await ordinazioneControl.addPietanzaToOrdinazione(2, 1), throwsA(isA<Exception>()));
    });

    //Aggiungere pietanza esistente in ordinazione inesistente
    test('Aggiunta pietanza inesistente all\'ordinazione 1 (l\'ordinazione è chiusa di default nel db attuale', () async {
      // Crea un'istanza della classe OrdinazioneControl
      var ordinazioneControl = OrdinazioneControl();

      // Prova ad aggiungere la pietanza con id 1 all'ordinazione inesistente con id 999999
      expect(() async => await ordinazioneControl.addPietanzaToOrdinazione(999999, 1), throwsA(isA<Exception>()));
    });

  });
}

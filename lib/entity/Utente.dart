import '../GlobImport.dart';
class Utente{//Singleton
  String _nome="";
  String _ruolo="";
  static final Utente _instance=Utente._internal();
  factory Utente(){
    return _instance;
  }


  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  Utente._internal();

  String get ruolo => _ruolo;

  set ruolo(String value) {
    _ruolo = value;
  }
}
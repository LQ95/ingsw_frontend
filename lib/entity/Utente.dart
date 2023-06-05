import 'dart:ffi';
import '../GlobImport.dart';
class Utente{//Singleton
  String _nome="";
  String _ruolo="";
  String _primoAccesso="";
  int _id=0;

  String get getNome => _nome;

  @override
  String toString() {
    return 'Utente{_nome: $_nome, _ruolo: $_ruolo, _primoAccesso: $_primoAccesso, _id: $_id}';
  }

  set setNome(String value) {
    _nome = value;
  }

  static final Utente _instance=Utente._internal();
  factory Utente(){
    return _instance;
  }

  Utente._internal();

  String get getRuolo => _ruolo;

  set setRuolo(String value) {
    _ruolo = value;
  }

  String get isPrimoAccesso => _primoAccesso;

  set setPrimoAccesso(String value) {
    _primoAccesso = value;
  }

  int get getId => _id;

  set setId(int value) {
    _id = value;
  }
}
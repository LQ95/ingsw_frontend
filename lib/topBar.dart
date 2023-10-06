import 'dart:isolate';
import 'package:flutter/material.dart';
import 'SchermataFunzioniAmministratore.dart';
import 'SchermataLogin.dart';
import 'SchermataMessaggi.dart';
import 'entity/Utente.dart';
import 'package:quickalert/quickalert.dart';

var port= ReceivePort();
var outputFromIsolate;
var sendPort; //inizializzati propriamente nel punto in cui è spawnato l'isolate.

Future<void> showAlertNuoviMess(BuildContext context) async {
  bool show = await outputFromIsolate.next;
  if(show) {
    QuickAlert.show(context: context,
        type: QuickAlertType.info,
        text: "Nuovi messaggi",
        title: "Attenzione",
        onConfirmBtnTap: (){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => SchermataMessaggi()),
          );

        }
    );
  }
}


ListTile FunzioniAdmin(BuildContext context) {
  return ListTile(
    title: const Text("Funzioni Admin"),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SchermataFunzioniAmministratore()),
      );
    },
    trailing: const Icon(Icons.admin_panel_settings),
  );
}

ListTile Notifiche(BuildContext context) {
  return ListTile(
    title: const Text("Notifiche"),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SchermataMessaggi()),
      );
    },
    trailing: const Icon(Icons.mail_outlined),
  );
}

ListTile Logout(BuildContext context) {
  return ListTile(
    title: const Text("Logout"),
    onTap: () {
      showAlertConfermaLogout(context);
    },
    trailing: const Icon(Icons.logout),
  );
}

var GlobalAppBar=
AppBar(
  title: const Text("Ratatouille23",),
);

Drawer buildDrawer(BuildContext context) {
  if (Utente().getRuolo == "AMMINISTRATORE") {
    return Drawer(
      child: ListView(
        children: [
          FunzioniAdmin(context),
          Notifiche(context),
          Logout(context),
        ],
      ),
    );
  } else {
    return Drawer(
      child: ListView(
        children: [
          Notifiche(context),
          Logout(context),
        ],
      ),
    );
  }
}

void showAlertConfermaLogout(BuildContext context) {
  QuickAlert.show(context: context,
    type: QuickAlertType.confirm,
    text: "",
    title: "Sei sicuro di voler uscire?",
    confirmBtnText: "Si",
    cancelBtnText: "No",
    onConfirmBtnTap: () async {
      Utente utente = Utente();
      utente.setNome = "";
      utente.setRuolo= "";
      utente.setPrimoAccesso= "";
      utente.setId = -1;
      sendPort.send(null);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>SchermataLogin()));  //Cancella lo stack e naviga verso login
      await outputFromIsolate.cancel(immediate: true);
      outputFromIsolate=null;
    },
    onCancelBtnTap: () => Navigator.pop(context),
  );
}



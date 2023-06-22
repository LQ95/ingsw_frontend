import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataFunzioniAmministratore.dart';
import 'package:ingsw_frontend/SchermataLogin.dart';
import 'entity/Utente.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ingsw_frontend/SchermataMessaggi.dart';

const String baseUrl = '192.168.1.138:8080'; //Ip Marco  192.168.1.138:8080

Map<String, dynamic> globalUnreadMessages= HashMap();

// ListTile funzioniAdmin=ListTile(
//   title:  const Text("Funzioni Admin"),
//   onTap: () {Navigator.push(localcontext, MaterialPageRoute(builder: (context) =>SchermataFunzioniAmministratore()));}, //IMPORTANTE SETTARE LOCALCONTEXT OGNI VOLTA OPPURE TROVRE UN MODO PER RICOSTRUIRLO
//   trailing: const Icon(Icons.admin_panel_settings),
// );
//
// ListTile notifiche=ListTile(
//   title: const Text("Notifiche"),
//   onTap: () {Navigator.push(localcontext, MaterialPageRoute(builder: (context) =>SchermataMessaggi()));},
//   trailing: const Icon(Icons.mail_outlined),
// );
// ListTile logout= ListTile(
//   title: const Text("Logout"),
//   onTap: () {showAlertConferma();},
//   trailing: const Icon(Icons.logout),
// );

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

// var globalDrawer=null;
//
// var adminDrawer= Drawer(
//   child: ListView(
//     children: [
//       funzioniAdmin,
//       notifiche,
//       logout
//     ],
//   ),
// );
// var userDrawer=Drawer(
//   child: ListView(
//     children: [
//       notifiche,
//       logout
//     ],
//   ),
// );
//
// void selectDrawer(){
//   if(Utente().getRuolo == "AMMINISTRATORE")
//     globalDrawer=adminDrawer;
//   else globalDrawer=userDrawer;
// }

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
    onConfirmBtnTap: () {
      Utente utente = Utente();
      utente.setNome = "";
      utente.setRuolo= "";
      utente.setPrimoAccesso= "";
      utente.setId = -1;
      //NotificationCheck.kill();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>SchermataLogin()));  //Cancella lo stack e naviga verso login
    },
    onCancelBtnTap: () => Navigator.pop(context),
  );
}



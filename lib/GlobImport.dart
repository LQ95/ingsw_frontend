import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataFunzioniAmministratore.dart';
import 'package:ingsw_frontend/SchermataLogin.dart';
import 'entity/Utente.dart';
import 'package:quickalert/quickalert.dart';



var localcontext=null;
var GlobalAppBar=
AppBar(
  title: const Text("Ratatouille23",),
      );

var globalDrawer=
     Drawer(
      child: ListView(
        children: [
          ListTile(
            title:  const Text("Funzioni Admin"),
            onTap: () {Navigator.push(localcontext, MaterialPageRoute(builder: (context) =>SchermataFunzioniAmministratore()));}, //IMPORTANTE SETTARE LOCALCONTEXT OGNI VOLTA OPPURE TROVRE UN MODO PER RICOSTRUIRLO
            trailing: const Icon(Icons.admin_panel_settings),
          ),
          ListTile(
            title: const Text("Notifiche"),
            onTap: () {},
            trailing: const Icon(Icons.mail_outlined),
          ),
          ListTile(
            title: const Text("Logout"),
            onTap: () {showAllertConferma();},
            trailing: const Icon(Icons.logout),
          )
        ],

      ),
    );

void showAllertConferma() {
  QuickAlert.show(context: localcontext,
      type: QuickAlertType.confirm,
      text: "",
      title: "Sei sicuro di voler uscire?",
      confirmBtnText: "Si",
      cancelBtnText: "no",
      onConfirmBtnTap: () {
        Utente utente = Utente();
        utente.setNome = "";
        utente.setRuolo= "";
        Navigator.pushReplacement(localcontext, MaterialPageRoute(builder: (context) =>SchermataLogin()));  //Cancella lo stack e naviga verso login
      },
      onCancelBtnTap: () => Navigator.pop(localcontext),
  );
}


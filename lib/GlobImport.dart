import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataFunzioniAmministratore.dart';
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
            title: const Text("Logout"),
            onTap: () {},
            trailing: const Icon(Icons.logout),
          )
        ],

      ),
    );
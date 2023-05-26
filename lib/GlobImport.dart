import 'package:flutter/material.dart';
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
            onTap: () {},
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
import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataScriviMessaggio.dart';
import 'package:ingsw_frontend/control/MessaggiControl.dart';
import 'package:ingsw_frontend/control/ThreadControl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'GlobImport.dart';
import 'entity/Utente.dart';


class SchermataMessaggi extends StatefulWidget {
  final String title = "SchermataMessaggi";

  const SchermataMessaggi({super.key});

  @override
  SchermataMessaggiState createState() => SchermataMessaggiState();
}

class SchermataMessaggiState extends State<SchermataMessaggi> {
  @override
  Widget build(BuildContext context) {
    // Calcolo dell'altezza dello schermo
    double width = MediaQuery.of(context).size.width;

    generaWidgetMessaggi() async {
      MessaggiControl db = MessaggiControl();
      try {
        List<dynamic>? listaMessaggi = await db.getAllMessaggiFromDB();
        if (listaMessaggi != null) {
          listaMessaggi = listaMessaggi?.reversed.toList();
          List<bool> wasUnreadList = await wasUnread(listaMessaggi);
          return Wrap(
            direction: Axis.vertical,
            children: List.generate(listaMessaggi!.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: SizedBox(
                  height: 300,
                  width: width * 0.7,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          spreadRadius: 5,
                          color: Color(0xAA110505),
                          offset: Offset(-8, 8),
                        )
                      ],
                      color: Color(0xFFC89117),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Mittente: " + listaMessaggi?[index]['mittente'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Row(
                                children: [
                                  statefulReadButton(
                                    listaMessaggi?[index]['id'],
                                    wasUnreadList[index],
                                    context, // Passa il contesto esplicitamente
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                listaMessaggi?[index]['corpo'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        } else {
          return const Text("");
        }
      } catch (e) {
        // Gestione dell'eccezione
        showAlertErrore("C'è stato un errore di connessione con il server, per favore riprova più tardi...");
      }
    }

    return Scaffold(
      appBar: GlobalAppBar,
      drawer: buildDrawer(context),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 9, right: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66420F),
                    ),
                    child: const Text(
                      "Torna Indietro",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Utente utente = Utente();
                      if (utente.getRuolo == "AMMINISTRATORE" || utente.getRuolo == "SUPERVISORE") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SchermataScriviMessaggi())).then((value) => setState(() {}));
                      } else {
                        showAlertErrore("Non hai i permessi necessari per eseguire quest'operazione");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66420F),
                    ),
                    child: const Text(
                      "Scrivi",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: generaWidgetMessaggi(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            final widgetMessaggi = snapshot.data;
                            if (widgetMessaggi == null) {
                              // Aggiungi qui la gestione per listaMessaggi o wasUnreadList nulli
                              return const Text("Errore nella lettura dei messaggi");
                            }
                            return widgetMessaggi;
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<bool>> wasUnread(List? listaMessaggi) async {
    List<bool> result = List<bool>.empty(growable: true);
    Map<String, dynamic> UnreadMessages = await MessaggiControl.getUnreadMessagesList(Utente());
    int i;
    for (i = 0; i < listaMessaggi!.length; i++) {
      result.add(UnreadMessages.containsValue(listaMessaggi[i]['id'])); //l'id di questo messaggio sta nei messaggi non letti?
    }
    return result;
  }

  void showAlertErrore(String errore) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: errore,
      title: "Attenzione!",
    );
  }

}

class statefulReadButton extends StatefulWidget {
  int messageId;
  bool unread = false;
  BuildContext context;

  statefulReadButton(this.messageId, this.unread, this.context);

  @override
  State<StatefulWidget> createState() => readButtonState(unread, messageId);
}

class readButtonState extends State<statefulReadButton> {
  static MessaggiControl db = new MessaggiControl();
  static const Color unreadBackground = Color(0xFF66420F);
  static const Color readBackground = Color(0xFFBBBBBB);
  Color background = readBackground;

  bool unread = false;

  static const Text unreadText = Text("Segnala visualizzazione", style: TextStyle(color: Colors.white70));
  static const Text readText = Text("Visualizzato", style: TextStyle(color: Colors.white70));
  Text buttonText = readText;

  int messageId = 0;

  readButtonState(bool unread, int messageId) {
    this.unread = unread;
    this.messageId = messageId;
    if (this.unread == true) {
      this.background = unreadBackground;
      this.buttonText = unreadText;
    }
  }

  void toggleRead() async {
    try {
      if (unread) {
        await db.setMessageAsRead(messageId);
        setState(() {
          background = readBackground;
          buttonText = readText;
        });
      }
    } catch (e) {
      // Gestione dell'eccezione
      showAlertErrore(
          "Errore nell'aggiornamento del messaggio"
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: toggleRead,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
      ),
      child: buttonText,
    );
  }

  void showAlertErrore(String errore) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: errore,
      title: "Attenzione!",
    );
  }
}

import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'GlobImport.dart';
import 'control/CategoriaControl.dart';

class SchermataSelezionaPietanza extends StatefulWidget{
  final String nomeCategoria;
  final int idCategoria;
  final int idTavolo;
  const SchermataSelezionaPietanza({Key? key, required this.nomeCategoria, required this.idCategoria, required this.idTavolo,})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SchermataSelezionaPietanzaState();

}

class SchermataSelezionaPietanzaState extends State<SchermataSelezionaPietanza> {

  Map<String, int> pietanzeSelezionate = {};

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Future<List<Widget>> generaWidgetPietanze() async {
      CategoriaControl dbCat = CategoriaControl();
      List<dynamic>? listaPietanze =
      await dbCat.getPietanzeFromCategoria(widget.idCategoria);
      listaPietanze = listaPietanze?.reversed.toList();
      if (listaPietanze != null) {
        List<int> contatori = [];

        return List.generate(
          listaPietanze.length,
              (index) {
            contatori.add(0);
            String nomePietanza = listaPietanze?[index]['name'];
            pietanzeSelezionate[nomePietanza] = contatori[index];
            return ContatorePietanza(
              pietanza: listaPietanze?[index],
              contatore: contatori[index],
              onDecrement: () {
                if (contatori[index] > 0) {
                  contatori[index]--;
                  pietanzeSelezionate[nomePietanza] = contatori[index];
                }
              },
              onIncrement: () {
                contatori[index]++;
                pietanzeSelezionate[nomePietanza] = contatori[index];
              },
            );
          },
        );
      } else {
        return [];
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
                      "Indietro",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const Text(
                    'Scegli quale pietanza aggiungere',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 32,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showAlertConferma();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66420F),
                    ),
                    child: const Text(
                      "Conferma",
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
                        FutureBuilder<List<Widget>>(
                          future: generaWidgetPietanze(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return Wrap(
                              direction: Axis.vertical,
                              children: snapshot.data!,
                            );
                          },
                        ),
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

  void showAlertConferma() async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: "Sei sicuro di voler confermare l'ordinzaione?",
      title: "Conferma",
      confirmBtnText: "Si",
      cancelBtnText: "No",
      onConfirmBtnTap: () async {
        print(pietanzeSelezionate);
        Navigator.pop(context);
      },
      onCancelBtnTap: () => Navigator.pop(context),
    );
  }

}


//CLASSE CONTATORE

class ContatorePietanza extends StatefulWidget {
  final dynamic pietanza;
  final int contatore;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const ContatorePietanza({
    Key? key,
    required this.pietanza,
    required this.contatore,
    required this.onDecrement,
    required this.onIncrement,
  }) : super(key: key);

  @override
  _ContatorePietanzaState createState() => _ContatorePietanzaState();
}

class _ContatorePietanzaState extends State<ContatorePietanza> {
  int contatore = 0;

  @override
  void initState() {
    super.initState();
    contatore = widget.contatore;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: SizedBox(
        height: 300,
        width: MediaQuery.of(context).size.width * 0.7,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 7,
                spreadRadius: 5,
                color: Color(0xAA110505),
                offset: Offset(-8, 8),
              ),
            ],
            color: Color(0xFF728514),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        widget.pietanza['name'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (contatore > 0) {
                              setState(() {
                                contatore--;
                              });
                              widget.onDecrement();
                            }
                          },
                          icon: Icon(Icons.remove),
                          iconSize: 24,
                          color: Colors.black87,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tightFor(width: 40, height: 40),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              contatore.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              contatore++;
                            });
                            widget.onIncrement();
                          },
                          icon: Icon(Icons.add),
                          iconSize: 24,
                          color: Colors.black87,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tightFor(width: 40, height: 40),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Descrizione: " + widget.pietanza['descrizione'],
                      style: const TextStyle(color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Allergeni: " + widget.pietanza['allergeni'],
                      style: const TextStyle(color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${widget.pietanza['costo']}€",
                      style: const TextStyle(color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

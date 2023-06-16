import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataScriviMessaggio.dart';
import 'package:ingsw_frontend/control/MessaggiControl.dart';
import 'package:ingsw_frontend/control/ThreadControl.dart';
import 'GlobImport.dart';
import 'entity/Utente.dart';

class SchermataMessaggi extends StatefulWidget{
  final String title="SchermataMessaggi"
  ;

  const SchermataMessaggi({super.key});
  @override
  SchermataMessaggiState createState() => SchermataMessaggiState();

}

class SchermataMessaggiState extends State<SchermataMessaggi> {

  @override
  Widget build(BuildContext context) {
    //Calcolo dell'altezza dello schermo
    double width = MediaQuery.of(context).size.width;

    generaWidgetMessaggi() async{

      MessaggiControl db = MessaggiControl();
      List<dynamic>? listaMessaggi = await  db.getAllMessaggiFromDB();
      listaMessaggi = listaMessaggi?.reversed.toList();
      print("genero widget messaggi, e controllo messaggi non letti dal punto di vista della schermata dei messaggi");
      List<bool> wasUnreadList=await wasUnread(listaMessaggi);
      if (listaMessaggi != null) {
        return Wrap(
          direction: Axis.vertical,
          children: List.generate(listaMessaggi.length, (index) =>
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: SizedBox(height: 300,
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
                        //border: Border.all(width: 0),
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
                                  Text("Mittente: "+ listaMessaggi?[index]['mittente'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,),
                                  Row(
                                    children: [
                                      /*const Text("Letto", style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12,
                                        ),
                                      ),*/
                                      statefulReadButton(listaMessaggi?[index]['id'], wasUnreadList[index]),
                                    ],
                                  )
                                ],
                              ),
                              Text(listaMessaggi?[index]['corpo'], overflow: TextOverflow
                                  .ellipsis, maxLines: 11,),
                            ]
                        ),
                      ),
                    )
                ),
              ),),
        );
      }
      else {
        return const Text("");
      }
    }
    print("buildo");
    return Scaffold(
      appBar: GlobalAppBar,
      drawer: globalDrawer,
      body: Center(
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 9, right: 18),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: () {
                        Navigator.of(context).pop();
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Torna Indietro", style: TextStyle(
                            color: Colors.white70),),
                      ),
                      ElevatedButton(onPressed: () {
                        Utente utente = Utente();
                        if (utente.getRuolo == "AMMINISTRATORE" || utente.getRuolo == "SUPERVISORE") {
                          Navigator.push(
                              localcontext, MaterialPageRoute(builder: (
                              context) => const SchermataScriviMessaggi())).then((value) => setState(() {}));
                        }
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66420F),
                        ),
                        child: const Text("Scrivi", style: TextStyle(
                            color: Colors.white70),),
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
                              builder: (context, snapshot){
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError){
                                  return Text(snapshot.error.toString());
                                } else {
                                  return snapshot.data!;
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]
          )
      ),
    );
  }




  Future<List<bool>> wasUnread(List? listaMessaggi) async {
    List<bool> result= List<bool>.empty(growable:true);
    Map<String, dynamic> UnreadMessages=await MessaggiControl.getUnreadMessagesList(Utente());
    int i;
    print("avendo:");
    print(UnreadMessages);
    for(i=0;i<listaMessaggi!.length;i++){
      print("aggiorno lista booleani");
    result.add(UnreadMessages.containsValue(listaMessaggi[i]['id'])); //l'id di questo messaggio sta nei messaggi non letti?
    }
    return result;
  }
}
/*
class statefulReadButton extends StatefulWidget {
  int messageId;
  bool unread = false;

  statefulReadButton(this.messageId, this.unread);

  @override
  State<StatefulWidget> createState() => readButtonState(unread, messageId);
}

class readButtonState extends State<statefulReadButton> {
  static MessaggiControl db = new MessaggiControl();
  static const Color unreadBackground = Color(0xFF66420F);
  static const Color readBackground = Color(0xFFBBBBBB);
  Color background = readBackground;

  bool unread = false;

  int messageId = 0;

  readButtonState(bool unread, int messageId) {
    this.unread = unread;
    this.messageId = messageId;
    if (this.unread) {
      this.background = unreadBackground;
    }
  }

  void toggleRead(bool? value) {
    setState(() {
      unread = value!;

      if (unread) {
        background = unreadBackground;
        db.setMessageAsRead(messageId);
        eliminateMessageFromUnreadList(messageId);
      } else {
        background = readBackground;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: unread,
      onChanged: toggleRead,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      activeColor: unreadBackground,
      fillColor: MaterialStateProperty.all<Color>(background),
      visualDensity: VisualDensity.compact,
    );
  }

  void eliminateMessageFromUnreadList(int messageId) {
    String keyNumber;
    String key;
    if (globalUnreadMessages.containsValue(messageId)) {
      key = globalUnreadMessages.keys.firstWhere(
            (k) => globalUnreadMessages[k] == messageId,
      );
      keyNumber = key.replaceAll("id", "");
      globalUnreadMessages.remove(key);
      globalUnreadMessages.remove("mittente$keyNumber");
      globalUnreadMessages.remove("corpo$keyNumber");
    }
  }
}

 */

class statefulReadButton extends StatefulWidget {

  int messageId;
  bool unread=false;
  statefulReadButton(this.messageId,this.unread);

  @override
  State<StatefulWidget> createState() => readButtonState(unread,messageId);

}


class readButtonState extends State<statefulReadButton>{
  static MessaggiControl db = new MessaggiControl();
  static const Color unreadBackground= Color(0xFF66420F);
  static const Color readBackground= Color(0xFFBBBBBB);
  Color background=readBackground;

  bool unread = false;

  static const Text unreadText= Text("Segnala visualizzazione", style: TextStyle(
      color: Colors.white70),);
  static const Text readText= Text("Visualizzato", style: TextStyle(
      color: Colors.white70),);
  Text buttonText=readText;

  int messageId=0;


  readButtonState( bool unread, int messageId){
    this.unread=unread;
    this.messageId=messageId;
    if(this.unread == true){
      this.background=unreadBackground;
      this.buttonText=unreadText;
    }
  }

  void toggleRead(){
    setState(() {

      if(unread){
        background=readBackground;
        buttonText=readText;
        db.setMessageAsRead(messageId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed:toggleRead,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
      ),
      child: buttonText
    );
  }

}



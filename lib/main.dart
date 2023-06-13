import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ingsw_frontend/SchermataLogin.dart';
import 'package:ingsw_frontend/control/UtenteControl.dart';
import 'package:window_size/window_size.dart';
import 'dart:io' show Platform;
import 'InitAmministratoreHomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Ratatouille23');
    setWindowMinSize(const Size(1280, 720));
  }
  UtenteControl db= UtenteControl();
  Widget schermataHome;
  int initialized = await db.isSistemInitialized() ;
  if (initialized == 1) {
    schermataHome=const InitAmministratoreHomePage();
  } else {
    schermataHome= SchermataLogin();
  }
  runApp(MyApp(schermataHome));
}

class MyApp extends StatelessWidget {


  MyApp(this.schermataHome, {super.key})
  {
    super.key;
  }

  Widget schermataHome=SchermataLogin();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'Segoe UI',
        colorScheme: const ColorScheme(brightness:Brightness.light,primary:Color(0xFF66420f),
            background:Color(0xFFeac953),error:CupertinoColors.lightBackgroundGray,onBackground:Colors.black,
            onError:Color(0xFFa81528),onPrimary:Colors.white54,onSecondary:Colors.black45,onSurface:Colors.black45,
        secondary:Color(0xFFC89117),surface:Color(0xFF728514)),
        useMaterial3: true,
      ),
      home: schermataHome,
    );
  }
}






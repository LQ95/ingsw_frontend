import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme(brightness:Brightness.light,primary:Color(0xFF66420f),
            background:Color(0xFFeac953),error:CupertinoColors.lightBackgroundGray,onBackground:Colors.black,
            onError:Color(0xFFa81528),onPrimary:Colors.white54,onSecondary:Colors.black45,onSurface:Colors.black45,
        secondary:Color(0xFFC89117),surface:Color(0xFF728514)),
        useMaterial3: true,
      ),
      home: const LoginHomePage(),
    );
  }
}




import 'package:chat_app/push_notify.dart';
import 'package:chat_app/sign_up.dart';
import 'package:chat_app/switch.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:switch_screen(),//Scaffold(appBar: AppBar(backgroundColor: Colors.blue,),backgroundColor: Colors.amber,)

    );

  }
}




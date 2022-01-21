import 'package:chat_app/saved_data.dart';
import 'package:chat_app/sign_in.dart';
import 'package:chat_app/sign_up.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'chatRoom.dart';
import 'database.dart';

class switch_screen extends StatefulWidget {
  @override
  _switch_screenState createState() => _switch_screenState();
}

class _switch_screenState extends State<switch_screen> {
  bool ShowSignin=true;
  Database database =new Database();

  void switch_sign(){
    setState(() {
      ShowSignin = !ShowSignin;
    });
  }
  logmein(BuildContext context) async{
    bool isloggedin =false;
    isloggedin = await Sign_in_Data.getIsLoggedIn();
    String token=await FirebaseMessaging.instance.getToken();
    if (isloggedin){database.getUsername(await Sign_in_Data.getmail(),token).then((x){
      Sign_in_Data.saveName(x.docs[0].data()["name"]);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatRoom(x.docs[0].data()["name"])));
    });}
  }

  @override
  Widget build(BuildContext context) {
    logmein(context);
    if (ShowSignin){
      return sign_in(switch_sign);}
    else {
      return sign_up(switch_sign);
    }

  }
}

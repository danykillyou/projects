import 'dart:io';

import 'package:chat_app/chatRoom.dart';
import 'package:chat_app/database.dart';
import 'package:chat_app/saved_data.dart';
import 'package:chat_app/switch.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/auth.dart';
import 'package:firebase_core/firebase_core.dart';
class sign_in extends StatefulWidget {
  @override
  final Function switch_sign;
  sign_in(this.switch_sign);


  _sign_inState createState() => _sign_inState();
}

class _sign_inState extends State<sign_in> {
  TextEditingController mail = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  Icon Eyeicon=Icon(Icons.remove_red_eye);
  bool notvisibal = true,isLoading=false;
  AuthMethods authMethods = new AuthMethods();
  Database database =new Database();
  String error="";


  SignMein(){

    if(formKey.currentState.validate()){
      setState(() {isLoading=true;});
      authMethods.signInWithmailandPass(mail.text,pass.text).then((val){
        if(val!=null)
     {
       // Sign_in_Data.saveName(name.text);
       String token="";
       FirebaseMessaging.instance.getToken().then((token) {print(token);

        Sign_in_Data.saveIsLoggedIn(true);
        database.getUsername(mail.text,token).then((x){
          print(x.docs[0].data()["name"]);
          Sign_in_Data.saveMail(x.docs[0].data()["mail"]);
          Sign_in_Data.saveName(x.docs[0].data()["name"]);


       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>new ChatRoom(x.docs[0].data()["name"])));
        });
     });
       }
      else {
            error="email or password are incorrect";
            setState(() {
              isLoading=false;
            });
        }
      });
    }}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.indigo[900],
        title: Container(child: GestureDetector(child: Text("sign in",style: TextStyle(fontSize: 25),),
          onTap: (){
          mail.text="ben@gmail.com";
          pass.text="benben";
          SignMein();
          },),)
        ,
      ),
      backgroundColor: Colors.grey,
      body:isLoading? Center(child: Container(child: CircularProgressIndicator(),)):SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:100),
            Form(
              key: formKey,
              child: Column(
                children: [

                  Container(
                    padding:EdgeInsets.all(20) ,

                    child: TextFormField(
                      style: TextStyle(color: Colors.white,backgroundColor: Colors.black38),
                      validator: (val){
                        // ignore: valid_regexps
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Enter correct email";},
                      controller: mail,
                      decoration: InputDecoration(
                          hintText: "mail",
                          hintStyle: TextStyle(color: Colors.white,backgroundColor: Colors.black38)
                      ),

                    ),
                  ),
                  Row(
                    children: [
                      new Flexible(
                        child: Padding(padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                            child: new TextFormField(

                              obscureText: notvisibal,
                              validator:  (val){
                                return val.length < 6 ? "Enter Password 6+ characters" : null;},
                              controller: pass,
                              style: TextStyle(color: Colors.white,backgroundColor: Colors.black38),
                              decoration: InputDecoration(
                                hintText: "password",
                                hintStyle: TextStyle(color: Colors.white,backgroundColor: Colors.black38),

                              ),

                            )),
                      ),
                      GestureDetector(child:Eyeicon ,
                        onTap:(){
                          setState(() {
                            notvisibal = !notvisibal;
                            if(!notvisibal)
                            {Eyeicon = Icon(Icons.remove);}
                            else{Eyeicon=Icon(Icons.remove_red_eye);}
                          });
                        },)
                    ],

                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [Padding(
                      padding: const EdgeInsets.fromLTRB(20,0,10,0),
                      child: Text("Don't have account?",style: TextStyle(fontSize: 20)),
                    ),GestureDetector(child: Container(padding: EdgeInsets.symmetric(vertical: 12),child: Text("Sign up",style: TextStyle(fontSize: 20,decoration:TextDecoration.underline ),)),
                      onTap: (){
                        widget.switch_sign();
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>switch_screen()));
                      },)],
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),

            Center(child: Container(child: Text(error,style: TextStyle(color: Colors.red),),)),
            SizedBox(height: 20,),
            GestureDetector(
                child: Container(
                  //padding: EdgeInsets.all(30),
                  child: Text("sign in",style:TextStyle(color: Colors.white,fontSize: 30) ,textAlign: TextAlign.center,),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.blue),
                  width: MediaQuery.of(context).size.width-80,
                  height: 50,
                ),
                onTap: () {
                  SignMein();

                } ),
            SizedBox(height:25),
            GestureDetector(
                child: Container(
                  // padding: EdgeInsets.fromLTRB(0),
                  child: Text("sign in with GOOGLE",style:TextStyle(color: Colors.white,fontSize: 30) ,textAlign: TextAlign.center,),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.deepPurpleAccent),
                  width: MediaQuery.of(context).size.width-80,
                  height: 50,
                ),
                onTap: () async {
                  setState(() {});

                  var x =await authMethods.signInwithGoogle();
                  print(x.additionalUserInfo.profile["email"].toString()+"  google");
                  // Sign_in_Data.saveName(name.text);
                  String token="";
                  FirebaseMessaging.instance.getToken().then((token) {print(token+" token");

                  Sign_in_Data.saveIsLoggedIn(true);
                  database.getUsername(x.additionalUserInfo.profile["email"],token).then((x){
                    print(x.docs[0].data()["name"]);
                    Sign_in_Data.saveMail(x.docs[0].data()["mail"]);
                    Sign_in_Data.saveName(x.docs[0].data()["name"]);


                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>new ChatRoom(x.docs[0].data()["name"])));
                  });
                  });

                }),

          ],
        ),
      ),
    );
  }
}

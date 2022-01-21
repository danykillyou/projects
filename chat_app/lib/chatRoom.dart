import 'dart:io';

import 'package:chat_app/database.dart';
import 'package:chat_app/saved_data.dart';
import 'package:chat_app/search.dart';
import 'package:chat_app/sign_in.dart';
import 'package:chat_app/switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Converstion_screen.dart';
import 'User.dart';
import 'auth.dart';
class ChatRoom extends StatefulWidget {
  String myname;
  ChatRoom(this.myname);

  @override

  _ChatRoomState createState() => _ChatRoomState();
}
class _ChatRoomState extends State<ChatRoom> {
Database database =new Database();

Stream rooms;
chatId chat =new chatId();


  void initState() {
    // start_conv();
    // sleep(Duration(seconds:1));

    start_conv();

    super.initState();
  }
  start_conv()async{

    // myname= myname1;
    print("myname is: "+widget.myname);
    rooms =await database.getallchats(widget.myname);
      setState(() {

      } );
    // print(rooms.docs[0].data());
  }
  @override
  AuthMethods authMethods = new AuthMethods();

  Widget build(BuildContext context) {
    var x= Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.indigo[900],
        title: GestureDetector(onTap: (){setState(() {

        });},child: Container(child: widget.myname==null? Container():Text(widget.myname ,style: TextStyle(fontSize: 25),),))
        ,actions: [GestureDetector(onTap: (){authMethods.SignOut(); database.removetoken();
      Sign_in_Data.saveIsLoggedIn(false);
      Sign_in_Data.savesize(23);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>switch_screen()));
        },child: Container(padding: EdgeInsets.all(16),child: Icon(Icons.exit_to_app_sharp)))],
      ),
  body: Column(
    children: [
      Flexible(child:  Searched_users_list()),
    ],
  )
      ,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.search_rounded),onPressed: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Search_screen(chat:chat)));}),

    );
    // start_conv();
    return x;
  }

  Widget Searched_users_list(){

    if(rooms==null){return Container(child: Text("error"));}
    return StreamBuilder(stream: rooms, builder:
        (context, snapshot) {
      print(rooms.toString() + "lllllllllllllllll");
      // print(snapshot.data.docs[snapshot.data.docs.length-1].toString() + "lllaaaaaa");
      return !snapshot.hasData ? Container():ListView.builder(
          itemCount: snapshot == null ? 0 : snapshot.data.docs.length,
          itemBuilder: (context, index) {
            // print(snapshot.data.docs[index].id.toString()+"zazaz");

            var x;
            if(snapshot.data.docs[index].get("name")==null){
              x=snapshot.data.docs[index].get("users");
              print(x.toString());
              x.remove(widget.myname);
              x=x.toString().substring(1,x.toString().length-1);
            }
           else{
             x=snapshot.data.docs[index].get("name");
            }
print("mmmmmmmmmmmmmmmmmmmm");
           try{
                      print(snapshot.data.docs[index].id);
                      chat.newchatId(
                          chat_id: snapshot.data.docs[index].id,
                          chat_name: x
                              );
                      print("000000000000000000000000");

           }catch(e){print(e.toString());}
                    return Searched_users(chat_name: x,id:snapshot.data.docs[index].id ,myname: widget.myname,);
          }
      );
    }) ;
}
    // return rooms.docs.isEmpty? Container():ListView.builder(itemCount:rooms.docs.length ,
    //     shrinkWrap: true,
    //     itemBuilder: (context,index)
    //     {
    //       print("building");
    //       print(rooms.docs[0].data()["users"]);
    //       var x=rooms.docs[index].data()["users"];
    //          // x= x.split(",");
    //          x.remove(myname);
    //          //  print(x.toString());
    //       return  Searched_users(name:x.toString().substring(1,x.toString().length-1));
        }


class Searched_users extends StatelessWidget {
  final String myname;
  final String chat_name;
  final String id;
  Searched_users({this.chat_name,this.id,this.myname} );
  Database database=new Database();

  CreateRoom(BuildContext context)async{Navigator.push(context, MaterialPageRoute(builder: (context)=> Conv_screen( myname:myname,chat_name1: chat_name,room_id: id,) ));}

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
        child:Row(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chat_name,style: TextStyle(fontSize: 30,color: Colors.black),),
              ],),Spacer(),
            GestureDetector(
              onTap: (){CreateRoom(context);},
              child: Container(child: Text("message",style: TextStyle(fontSize: 20)),
                decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(30)),padding: EdgeInsets.all(15),),
            )
          ],
        )
    );
  }
}

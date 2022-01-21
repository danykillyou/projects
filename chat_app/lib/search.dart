import 'package:chat_app/User.dart';
import 'package:chat_app/database.dart';
import 'package:chat_app/saved_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Converstion_screen.dart';

Future<List<String>> Sort_users(String name)async{
String myname = await Sign_in_Data.getname();

List<String> users=[myname,name];
users.sort((a,b)=>a.compareTo(b));
return users;
}

class Search_screen extends StatefulWidget {
  @override
  final chatId chat;
  Search_screen({ Key key, this.chat }): super(key: key);
  _Search_screenState createState() => _Search_screenState();
}

class _Search_screenState extends State<Search_screen> {
  TextEditingController search = new TextEditingController();
  Database database=new Database();
  String myname ="";

  QuerySnapshot res;



  start_search(){
    database.getUserwithUsername(search.text).then((res1){
      setState(() {
        res=res1;
        widget.chat.Printtt();
        print(widget.chat.chats.toString());
        // print(res.docs[0].data());

      });
    });
  }

 Widget Searched_users_list(){



   return res ==null? Container():ListView.builder(itemCount:res.docs.length ,
       shrinkWrap: true,
       itemBuilder: (context,index)
       {
         print(res.docs[index].get("name"));
     return Searched_users(
         name:res.docs[index].get("name"),
         mail:res.docs[index].get("mail"),myname:myname);
     });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor:Colors.indigo[900],
        title: Container(child: Text("Search",style: TextStyle(fontSize: 25),),),

      ),
      backgroundColor: Colors.white70,
      body: Container(child: Column(children: [
        Container(
          color:Colors.grey ,
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          child: Row(children: [
            Expanded(
              child: TextField(
                onChanged: (String v) {setState(() {start_search();    });
                },
                controller: search,
                // textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: "search User...",
              border: InputBorder.none,
            ),
              ),
            ),GestureDetector(child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0x36ffffff),Color(0x0fffffff)]),borderRadius: BorderRadius.circular(15)),child: Icon(Icons.search,size: 35,))

              ,onTap: ()async{
                myname= await Sign_in_Data.getname();

                setState(() {
                start_search();
                  print("doneee");
              });

              },
            )
          ],),

        ),
        Flexible(child: Searched_users_list()),


      ],),),
    );


  }

}

class Searched_users extends StatelessWidget {

  final String name;
  final String myname;
  final String mail;
  Searched_users({this.name,this.mail,this.myname} );



  Database database=new Database();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Create new chat'),
            content: Text("Do you want to start a NEW chat with this person?"),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {

                    Navigator.pop(context);

                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {

                    CreateRoom(context);
                    Navigator.pop(context);

                },
              ),
            ],
          );
        });
  }

  CreateRoom(BuildContext context)async{
    List<String> users= await Sort_users(name);
    String chat_name = users.toString() ;//name.substring(0,1).codeUnitAt(0) >  myname.substring(0,1).codeUnitAt(0)? myname+"_"+name:name+"_"+myname;
    print(users);
    Map<String,dynamic> room_map = {
      "users":users,
      "name":chat_name
    };
    database.createChatRoom( room_map).then((val){
      // print(val+" ccccccc");
      if (val==null){

        // Navigator.push(context, MaterialPageRoute(builder: (context)=>new Conv_screen( chat_name1: name,myname: myname,room_id: " ",) ));

      }

    });
  }

  @override

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
      child:Row(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(name,style: TextStyle(fontSize: 30),),
            Container(child: Text(mail,style: TextStyle(fontSize: 20)),padding: EdgeInsets.symmetric(vertical: 7),)
          ],),Spacer(),
          GestureDetector(
            onTap: (){
              _displayTextInputDialog(context);

            },
            child: Container(child: Text("message",style: TextStyle(fontSize: 20)),
            decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(30)),padding: EdgeInsets.all(15),),
          )
        ],
    )
    );
  }
}


import 'dart:convert' show utf8;

import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:chat_app/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipeable/swipeable.dart';
import 'package:file_picker/file_picker.dart';
import 'face_detection_camera.dart';

class Conv_screen extends StatefulWidget {


  final chat_name1;
  final String room_id;

  final String myname;
  Conv_screen({ Key key, this.chat_name1,this.room_id,this.myname }): super(key: key);
  @override

  _Conv_screenState createState() => _Conv_screenState();
}

class _Conv_screenState extends State<Conv_screen> {
  String text_final;
  final ScrollController scrollController = new ScrollController();
  final TextEditingController _textFieldController= new TextEditingController();
  String comment="";
  bool needsScroll=false;
  var chat_name;
  void initState() {
     chat_name= widget.chat_name1;

  start_conv();
    super.initState();
  }

  start_conv()async{
    messages =await database.getchat(widget.chat_name1,widget.room_id);
    {  setState(() { } );}
    // print(res.docs[0].data());
  }

  _scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
  scrollToEnd(){
    // sleep(Duration(milliseconds:500));

    // setState(() {
    try{
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut
      );
    }
      catch(e){print(e.toString());}
    // });
    }
    // print(res.docs[0].data());

  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => ));
        break;
      case 1:
        print("Privacy Clicked");
        break;

    }
  }

  @override
  Database database =new Database();
  // QuerySnapshot messeges;
  TextEditingController mess =new TextEditingController();
  Stream messages;
  double initHight=20;
  double Hight=20;
  Widget build(BuildContext context) {

    // scrollToEnd();
    var x= Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        actions: [PopupMenuButton(
          icon: Icon(Icons.menu),  //don't specify icon if you want 3 dot menu
          color: Colors.blue,
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 0,
              child: Text("Add member",style: TextStyle(color: Colors.white),),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Text("Change Chat name",style: TextStyle(color: Colors.white),),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Text("Change bg",style: TextStyle(color: Colors.white),),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Text("Leave chat",style: TextStyle(color: Colors.white),),
            ),
          ],
          onSelected: (item) => {
            print(item), SelectedItem(context, item)},
        ),],
        backgroundColor:Colors.indigo[900],
        title: Row(
          children: [
            GestureDetector(onTap: (){   setState(() {

            }); }
              ,child: Container(child: Text(chat_name,style: TextStyle(fontSize: 25),),)),
          GestureDetector(child: Container(child: Icon(Icons.drive_file_rename_outline),),
            onTap:(){_displayTextInputDialog(context);

            }
            
             ,),],
        )
        ,
      ),
      body: Column(
        children: [
          Flexible(child:  messages==null?Container(child:Text("not good")): GestureDetector(
              onScaleUpdate: ((ScaleUpdateDetails details){
                setState(() {
                  var size=4*initHight/7+(initHight*(details.scale*0.50));
                  print("init $initHight     size: $size  scale: ${details.scale}");
                  print("init $initHight     size: $size  scale: ${details.scale}");
                  Hight=size>50?   49:size>18?     size: 16   ;

                });

              }),
              onScaleEnd: ((ScaleEndDetails details){
                setState(() {
                  initHight=Hight;

                });
              }),
              child: Searched_users_list(widget.myname))),
          Container(
            color:Colors.grey ,
            padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(child: comment==""?null: Text(comment,style:TextStyle(fontSize: 18,color: Colors.white) ,),),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        controller: mess,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textDirection: TextDirection.rtl,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: "message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(child: Container(child: Icon(Icons.camera_alt),)
                 ,onTap: ()async{Navigator.push(context, MaterialPageRoute(builder: (context)=>FaceDetectionFromLiveCamera()));
                  }
                 ,),
                GestureDetector(child: Container(child: Icon(Icons.attach_file),),
                  onTap:() async {
                    var fb_file;
                  if(kIsWeb){FilePickerResult result = await FilePicker.platform.pickFiles();
      // print(result);
                  if (result != null) {

                    Uint8List fileBytes = result.files.first.bytes;
                    String fileName = result.files.first.name;

                    // Upload file
                    await firebase_storage.FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);
                    fb_file= await firebase_storage.FirebaseStorage.instance.ref('uploads/$fileName').getDownloadURL();
                    print(fb_file.toString());
                    // fb_file=utf8.decode(fb_file);
                  }}
                  else{
                    FilePickerResult result = await FilePicker.platform.pickFiles();

                    if (result != null) {
                      // Uint8List fileBytes = result.files.first.bytes;
                      String fileName = result.files.first.name;
                      String path = result.files.first.path;
                      // await firebase_storage.FirebaseStorage.instance.ref('uploads/$fileName').putFile(File(path));
                      //   print("xxxxxxxxxxxxxxxxxx");
                      fb_file =  await database.upload_file(path,fileName);
    }
                       print(fb_file.toString()+" zxzxzxzxzxzxzxxzxxz");
    }
                       send_mess("image_URL: "+fb_file, comment);


                  } ,),
                GestureDetector(child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0x36ffffff),Color(0x0fffffff)]),borderRadius: BorderRadius.circular(18)),child: Icon(Icons.send,size: 35,))

                  ,onTap: ()async{
                    // myname= await Sign_in_Data.getname();
                    setState(() {
                      send_mess(mess.text,comment);

                      print("doneee");
                    });

                  },
                )

              ],
            ),
          ),

        ],
      ),
    );

    return x;
  }
  String codeDialog;
  String valueText;
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Change the dialog name'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "new name"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    database.change_gruop_name(widget.room_id, valueText);
                    chat_name=valueText;
                    codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
  
  
  
Widget Searched_users_list(String myname){
  try {

    return messages ==null? Container(child: Text("error"),):

  messages != null ?
  StreamBuilder(stream: messages, builder:
      (context, snapshot) {

    print(messages.toString() + "lllllllllllllllll");

    var x= !snapshot.hasData? Container():ListView.builder(
        controller: scrollController,

        itemCount: messages == null ? 0 : snapshot.data.docs.length,
        itemBuilder: (context, index) {

          return
            GestureDetector(
            onLongPress: (){},
            child:
            messegesBlock(
              time:snapshot.data.docs[index].get("time") ,
                text: snapshot.data.docs[index].get("mess"),
                sendby: snapshot.data.docs[index].get("sendby"),
              comment_to: snapshot.data.docs[index].get("comment_to"),
              snapshot:snapshot,index:index
            ));
          // );
        }

    );
  needsScroll=true;
    messages.listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        scrollToEnd();
        print("scrolling");});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToEnd());

    return x;
  }) : Container(child: Text("error"));
}
catch(e){print(e.toString());}

}

  Longpress({snapshot,index})async{
    if(widget.myname==snapshot.data.docs[index].data()["sendby"]) {
      var id = await snapshot.data.docs[index].reference;

      id = id.toString().substring(
          40, id.toString().length - 1);
      print(id.toString()+"   THE ID ");
      openOptions(context, id,true);
    }
    else {
      var id = "";
      openOptions(context, id,false);
    }
  }


  Widget messegesBlock({sendby, text,comment_to,time,snapshot,index}) {
    // text_final=text;
    // var time1 = DateTime.parse(time.seconds.toString());
   var time1=new DateTime.fromMillisecondsSinceEpoch(time.seconds*1000);
   // print(time1.toString());
   var tim;
   if(time1.minute.toString().length==1){tim=time1.hour.toString()+":0"+time1.minute.toString();}
   else{tim=time1.hour.toString()+":"+time1.minute.toString();}

    return Swipeable(
      background: Container(color: Colors.grey,),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: widget.myname!=sendby ? Alignment.topRight:Alignment.topLeft,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24,vertical: 8),
        decoration: BoxDecoration(
          borderRadius: widget.myname!=sendby ?
            BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18),bottomLeft: Radius.circular(18)): BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18),bottomRight: Radius.circular(18))
          ,gradient: LinearGradient(
            colors:  widget.myname!=sendby ? [Colors.amber[700],Colors.red]:[Colors.white12,Colors.blue[800]]
          )
        ),
        child: Column(

          children: [
            widget.myname!=sendby?Container(child: Text(sendby),):Container(width: 1,),
            Container(child:comment_to==null||comment_to==""? Text("",style:TextStyle(fontSize: 1,color:Colors.red ) ,):comment_to.split(" ")[0]=="image_URL:"? Image.network(comment_to.split(" ")[1]):Text(comment_to,textDirection: TextDirection.rtl,style:TextStyle(fontSize: Hight-Hight/3,color: widget.myname==sendby?Colors.red:Colors.blue) ,),),



                Container(child:text.split(" ")[0]=="image_URL:"? Image.network(text.split(" ")[1]):Text(text,textDirection: TextDirection.rtl,style: TextStyle(color:Colors.white,fontSize: Hight),)),
             Container(child: Text( tim.toString(),style: TextStyle(fontSize: 10,),),)


          ],
        ),),
      ),
      onSwipeLeft:widget.myname==sendby?(){
        print("left");
        Longpress(snapshot: snapshot,index: index);
      }: (){
        setState(() {
          comment=text;
        });

      },
      onSwipeRight:widget.myname!=sendby?(){
        print("right");
        Longpress(snapshot: snapshot,index: index);
      }: (){
        setState(() {
          comment=text;
        }); },
    );

  }





  openOptions(BuildContext context,String id,bool delete) {
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        content:!delete? GestureDetector(child: Text("info")): GestureDetector(child: Text("delete"),
          onTap: ((){

              database.delete_mess(id);
              print("deleted");
              Navigator.of(context).pop();

          }),),
      );
    });
  }



send_mess(String text,String comment_to) {
var time=new DateTime.now();
    if(text !=""){
    Map<String,dynamic> messMap={
    "mess":text,
    "sendby":widget.myname,
      "comment_to":comment_to,
    "time":time};
    print(messMap.toString());

    database.sendmess(widget.room_id, messMap);
    mess.text="";
    // comment_to=comment;
    comment="";
    // needsScroll=true;
    }
}


}

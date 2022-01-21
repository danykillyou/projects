import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app/saved_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:chat_app/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'search.dart';

class Database{


  getUsername(String mail,String token)async{
     var x=await FirebaseFirestore.instance.collection("Users").where("mail",isEqualTo: mail.toLowerCase()).get();
     // StreamBuilder(stream: x, builder:
     //     (context, snapshot) {
     //     x.docs[0].data()["token"].set(token);
     //     return ListView();});
     var y= x.docs[0].id;
     print(y);
     // var z=[token];
     //     z.add(x.docs[0].data()["tokens"].toString().substring(1,x.docs[0].data()["tokens"].toString().length-1));
     // Map<String,dynamic> s=;
     // print(s.toString()+"/n z:"+z.toString());
     var z =await FirebaseFirestore.instance.doc("Users/${y}").update({"tokens":FieldValue.arrayUnion([token])}) ;
     // z=""
     return x;await FirebaseFirestore.instance.collection("Users").where("mail",isEqualTo: mail.toLowerCase()).get();

  }

  getUserwithUsername(String username) async{
    var x=  await FirebaseFirestore.instance.collection("Users").where("name",isGreaterThanOrEqualTo: username.toLowerCase()).get();
    print(x.toString());
    return x;
}

 UploadUser(Map<String,dynamic> data){
  return FirebaseFirestore.instance.collection("Users").add(data);
 }

 createChatRoom(room_map)async{
  var x= await FirebaseFirestore.instance.collection("chat_rooms").doc().set(room_map);
  // print(x.toString()+"  benbenben");
  return x;
 }
 getchat(String name,id)async{
    // var x = await Sort_users(name);
    // print(x.toString());
    // chats.chats[];
    // var  y= await FirebaseFirestore.instance.collection("/chat_rooms/").where("room_id",isEqualTo:x.toString()).get();
    // var z= await y.docs[0].id;
    return await FirebaseFirestore.instance.collection("/chat_rooms/"+id.toString()+"/chat").orderBy("time",descending: false).snapshots();
    // "/chat").orderBy("time",descending: false).snapshots();
    // z.docs[0].data().
 }
  getallchats(String name)async{

      var x=await FirebaseFirestore.instance.collection("chat_rooms").where("users",arrayContains: name).snapshots();
      print(x.toString());
    return x;

  }
sendmess(String id,messMap)async{

  print(id.toString()+"messss");
  FirebaseFirestore.instance.collection("/chat_rooms/"+id.toString()+"/chat").add(messMap).catchError((e){print(e.toString());});
}

  delete_mess(String id)async{
    print(id);
    var y= await FirebaseFirestore.instance.doc(id).delete();
  }

change_gruop_name(String id,new_name)async{
    print(id+"   44444");
    var y=FirebaseFirestore.instance.doc("/chat_rooms/"+id.toString()).update({"name":new_name});
    print(y);

}

upload_file(String path, fileName) async{
  // Upload file
  print(fileName);

  var x= await firebase_storage.FirebaseStorage.instance.ref('uploads/$fileName');
  print("55555555555");

await x.putFile(File(path));

  return  await firebase_storage.FirebaseStorage.instance.ref('uploads/$fileName').getDownloadURL();
}

  void removetoken() async{
    var x=await FirebaseFirestore.instance.collection("Users").where("mail",isEqualTo: await Sign_in_Data.getmail()).get();

    var y= x.docs[0].id;
    await FirebaseFirestore.instance.doc("Users/$y").update({"tokens":FieldValue.arrayRemove([await FirebaseMessaging.instance.getToken()])}) ;
  }
}
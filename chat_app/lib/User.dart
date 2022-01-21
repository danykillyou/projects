class UserId{
  String userid;

  UserId({this.userid});
}

class chatId{

  Map<String,String> chats={};
  chatId(){
    this.chats={};
  }

Printtt(){
  print(this.chats.toString()+" list");
}

  newchatId({String chat_name,String chat_id}){
    // this.chats={};
    Map<String,String> c=new Map.fromIterables([chat_name],[chat_id]);
    this.chats.addAll(c);
    print(c.toString());
    // print(this.chats.toString());
  }
}
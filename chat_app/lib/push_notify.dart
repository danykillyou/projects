
import 'package:firebase_messaging/firebase_messaging.dart';

class notify_service{
  static final FirebaseMessaging _fcm=FirebaseMessaging.instance;


  Future initalise() async{
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // if(Platform.isIOS){
    //   _fcm.requestNotificationPermissions();

    // }

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
        print("onMessage: " + message.data.toString());
        _fcm.getToken().then((token) {
          print(token + "   token  ");
        });
      }

    // _fcm.configure(
    //     onLaunch: (Map<String,dynamic> mess) async{
    //       print("onLaunch: $mess");
    //       _fcm.getToken().then((token){print(token+"   token  ");});
    //
    //     }
    // );
    // _fcm.configure(
    //     onResume: (Map<String,dynamic> mess) async{
    //       print("onResume: $mess");
    //       _fcm.getToken().then((token){print(token+"   token  ");});

        // }
    );
  }

}
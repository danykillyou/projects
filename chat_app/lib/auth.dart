import 'package:chat_app/User.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
    // final await Firebase.initializeApp() ;

  final FirebaseAuth _auth =FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();



  UserId _userfromfirebase(User user){
    print("user is "+(user != null).toString());
    return user != null? UserId(userid:user.uid) : null;
  }

  Future signInWithmailandPass(String mail,String pass) async{

    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: mail, password: pass);
      return _userfromfirebase(result.user);


    }catch(e){
    print(e.toString());}
  }

  Future Createuserwithmailandpass(String mail,String pass) async{
    try{

      UserCredential result =await _auth.createUserWithEmailAndPassword(email: mail, password: pass);
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

      return  _userfromfirebase(result.user);

    }catch(e){e.toString();
    print("failllllllllllll");}
  }

  Future resetPass(String mail) async{
    try{
        return await _auth.sendPasswordResetEmail(email: mail);
    }catch(e){print(e.toString());}
  }


  Future SignOut() async{
    try{

      await _googleSignIn.signOut();

      return await _auth.signOut;
    }catch(e){print(e.toString());}
  }

  Future signInwithGoogle() async {
    if(kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      var x= _auth.signInWithPopup(authProvider);
      return x;}
    try{
      final GoogleSignInAccount googleSignInAccount =
       await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,);
      print(credential);
      var x=await _auth.signInWithCredential(credential);
      return x;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> signOutFromGoogle() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
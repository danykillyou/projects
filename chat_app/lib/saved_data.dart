import 'package:shared_preferences/shared_preferences.dart';

class Sign_in_Data{

  static String LogInkey="isloggedin";
  static String Namekey="name";
  static String Mailkey="mail";
  static String Sizekey="hight";

  static Future<void> saveIsLoggedIn(bool isloggedin) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(LogInkey, isloggedin);

  }
  static Future<bool> saveName(String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Namekey, name);

  }

  static Future<bool> savesize(double size) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setDouble(Sizekey, size);

  }

  static Future<bool> saveMail(String mail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Mailkey, mail);

  }

  static Future<bool> getIsLoggedIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(LogInkey);

  }
  static Future<String> getname() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Namekey);

  }
  static Future<String> getmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(Mailkey);

  }

  static Future<double> getsize() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(Sizekey);

  }
}
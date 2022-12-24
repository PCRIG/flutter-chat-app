import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoggedInKey = 'LOGGEDINKEY';
  static String userNameKey = 'USERNAMEKEY';
  static String userEmailKey = 'USEREMAILKEY';

  static Future<bool> setUserLoggedInKeySf(bool isLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userLoggedInKey, isLoggedIn);
  }

  static Future<bool> setUserNameKeySf(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey, userName);
  }

  static Future<bool> setUserEmailKeySf(String email) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, email);
  }

  static Future<bool> setUserLoggedInDetails(
      bool isLoggedIn, String userName, String email) async {
    List<bool> result = await Future.wait([
      setUserLoggedInKeySf(isLoggedIn),
      setUserNameKeySf(userName),
      setUserEmailKeySf(email)
    ]);
    return result.every((element) => element);
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<bool> logoutUser() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.clear();
  }
}
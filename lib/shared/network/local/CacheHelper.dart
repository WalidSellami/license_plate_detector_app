import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {

  static SharedPreferences? sharedPreferences;


  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }


  static Future<bool?> saveCachedData({
    required String key,
    required dynamic value,
}) async {

    if(value is String) {
      return await sharedPreferences?.setString(key, value);
    } else if(value is bool) {
      return await sharedPreferences?.setBool(key, value);
    } else if(value is int) {
      return await sharedPreferences?.setInt(key, value);
    } else {
      return await sharedPreferences?.setDouble(key, value);
    }

  }


  static dynamic getCachedData({
    required String key,
}) {
    return sharedPreferences?.get(key);
  }


  static Future<bool?> removeCachedData({
    required String key,
}) async {
    return await sharedPreferences?.remove(key);
  }




}
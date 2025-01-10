import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_for_shared_preference/model/user_model.dart';

class PrefService {
  static storeUser(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String stringUser = jsonEncode(user);
    await sharedPreferences.setString('user', stringUser);
  }

  static Future<User?> loadUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? stringUser = sharedPreferences.getString('user');
    if (stringUser == null) return null;
    Map<String, dynamic> map = jsonDecode(stringUser);
    return User.fromJson(map);
  }

  static Future<bool> removeUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove('user');
  }
}

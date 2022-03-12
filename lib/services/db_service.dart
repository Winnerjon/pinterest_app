import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:pinterest_app/models/user_profile.dart';

class DbService {
  static String DBName = "PinterestProfil";
  static var box = Hive.box(DBName);

  static Future<void> storeUser(UserProfile userProfile) async {
    String user = jsonEncode(userProfile.toJson());
    await box.put("pinterest", user);
  }

  static UserProfile loadUser() {
    String? user = box.get("pinterest");
    if (user != null) {
      UserProfile userProfile = UserProfile.fromJson(jsonDecode(user));
      return userProfile;
    }
    return UserProfile(
        firstName: "Messi",
        lastName: "Lionel",
        userName: "@messi",
        email: "messi@gmail.com",
        gender: "male",
        age: 35,
        country: "Argentina");
  }
}

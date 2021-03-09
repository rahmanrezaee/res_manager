import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final baseUrl = "https://restaurant.webfumeprojects.online/api";
Future<String> gettoken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = json.decode(prefs.getString("user"))['token'];
  return token;
}

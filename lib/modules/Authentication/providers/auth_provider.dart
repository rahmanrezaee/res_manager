import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/api_path.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  Future login(String username, String password) async {
    try {
      print("Loging in");
      print({"email": username, "password": password});
      //sending data
      String url = "$baseUrl/admin/user/login";
      var res = await APIRequest().post(
        myUrl: url,
        myBody: {"email": username, "password": password},
      );
      //getting user data
      var user = {
        'token': res.data['data']['token'],
        'expierDate': DateTime.now().add(Duration(days: 1)).toString(),
        'userId': res.data['data']['user']['_id'],
      };
      //saving user data to sharedpreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(json.encode(user));
      await prefs.setString('user', json.encode(user));
      //return message
      return {"status": true, "message": "logedIn"};
    } on DioError catch (e) {
      print(e.response.data);
      return e.response.data;
    }
  }

  // token
  // expierdate
  // userid
  Future forgotPassword(email) async {
    String url = "$baseUrl/admin/user/forgotpassword";
    print(email);
    try {
      var res = await APIRequest().post(
        myUrl: url,
        myBody: {"email": email},
      );
      print(res);
      return {'status': true};
    } on DioError catch (e) {
      return e.response.data;
    }
  }
}

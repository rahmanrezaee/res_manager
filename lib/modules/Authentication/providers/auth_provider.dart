import 'dart:async';
import 'dart:developer';

import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/api_path.dart';
import 'package:admin/modules/Authentication/screen/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../validators/formFieldsValidators.dart';

class AuthProvider with ChangeNotifier {
  String? _token;

  DateTime? _expiryDate;

  Future<String> get userId async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') == null) {
      return '';
    } else {
      return json.decode(prefs.getString('user')!)['userId'];
    }
  }

  Future<String> get fcmToken async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') == null) {
      return '';
    } else {
      return json.decode(prefs.getString('user')!)['fcmToken'];
    }
  }

  Future login(String username, String password, String fcm) async {
    try {
      print("Loging in");
      print({"email": username, "password": password});
      //sending data
      String url = "$baseUrl/admin/user/login";
      var res = await APIRequest().post(
        myUrl: url,
        myBody: {"email": username, "password": password, "fcmToken": fcm},
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
      //

      this._token = res.data['data']['token'];
      this._expiryDate = DateTime.now().add(Duration(days: 1));

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
      print("error ${e.response}");
      return e.response.data;
    }
  }

  Future forgotPasswordWithKey(password, token) async {
    String url = "$baseUrl/admin/user/changepasswordwithKey";
    try {
      var res = await APIRequest().post(
        myUrl: url,
        myBody: {
          "token": token,
          "newPassword": password,
        },
      );
      print(res);
      return {'status': true};
    } on DioError catch (e) {
      return e.response.data;
    }
  }

  //Logout
  logOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _token = null;
    _expiryDate = null;
    prefs.remove('user');
  }

  get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  refreshToken() {}

  Future<bool> autoLogin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      log("data user:  ${prefs.getString('user')}");
      if (prefs.getString('user') == null) {
        _token = null;
      } else {
        DateTime expireDate =
            DateTime.parse(json.decode(prefs.getString('user')!)['expierDate']);

        if (expireDate != null && expireDate.isAfter(DateTime.now())) {
          log("data user: User Valided} ${json.decode(prefs.getString('user')!)['token']}");
          _token = json.decode(prefs.getString('user')!)['token'];
          _expiryDate = expireDate;

          log("data user: User Valided}$_token $_expiryDate");
          log("data user: User Valieded done");
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      print(e);

      return true;
    }
  }
}

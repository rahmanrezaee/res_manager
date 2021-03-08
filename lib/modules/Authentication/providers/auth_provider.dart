import 'dart:io';

import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/api_path.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider with ChangeNotifier {
  Dio dio = new Dio();
  Future login(String username, String password) async {
    try {
      // print("Loging in");
      // print({"email": username, "password": password});
      String url = "$baseUrl/admin/user/login";
      // print(url);
      var res = await APIRequest().post(
        myUrl: url,
        myBody: {"email": username, "password": password},
        myHeaders: null,
      );
      print(res);
      // await Future.delayed(Duration(seconds: 4));
      return false;
    } catch (e, s) {
      print("Stacktrace $s");
      print("Mahdi Error $e");
    }
  }

  Future forgotPassword(email) async {
    String url = "$baseUrl/admin/user/forgotpassword";
    // print(url);
    // var res = await APIRequest().post(
    //   myUrl: url,
    //   myBody: {"email": email},
    //   myHeaders: null,
    // );
    // print(res);
    await Future.delayed(Duration(seconds: 4));
    return true;
  }
}

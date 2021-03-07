import 'dart:io';

import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/api_path.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider with ChangeNotifier {
  Dio dio = new Dio();
  Future login(String username, String password) async {
    // try {
    // print("Loging in");
    print({"email": username, "password": password});
    String url = "$baseUrl/admin/user/login";
    print(url);
    var res = await dio.post(
      url,
      data: {"email": username, "password": password},
    );
    if (res.statusCode == 400) {
      print(res.data);
      return false;
    } else {
      print(res.data);
      return true;
    }
    // await Future.delayed(Duration(seconds: 4));
    // } catch (e, s) {
    //   print("Stacktrace $s");
    //   print("Mahdi Error $e");
    // }
  }

  Future forgotPassword(email) async {
    String url = "$baseUrl/admin/user/forgotpassword";
    print(email);
    // var res = await APIRequest().post(
    //   myUrl: url,
    //   myBody: {"email": email},
    //   myHeaders: null,
    // );
    var res = await dio.post(url, data: {"email": email});
    if (res.statusCode == 400) {
      return false;
    } else {
      return true;
    }
  }
}

import 'dart:developer';

import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/contentManagement/models/contentManagement.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ContentManagementprovider with ChangeNotifier {
  List<ContentManagementModel>? contentManagement;

  AuthProvider ?auth;
  ContentManagementprovider(this.auth);
  List<ContentManagementModel> get getContentManagement =>
      this.contentManagement!;

  Future submitContentMangement(String _dropdownController, String messasge,
      String slug, AuthProvider auth) async {
    try {
      var params = {
        "title": _dropdownController,
        "body": messasge,
        "slug": slug,
      };
      // ignore: unnecessary_brace_in_string_interps
      log("params ${params}");
      print('auth.token: ' + auth.token); //error is when we get token
      String url = "$baseUrl/public/pages/content";
      print(url);
      var result = await APIRequest().post(
          myUrl: url,
          myHeaders: {
            "token": auth.token,
          },
          myBody: params);
      log("result ${result.data}");
      return result.data;
    } on DioError catch (e) {
      print("Hello: submitContentManagement: error ${e.response}");
      if (e.response.statusCode == 400 || e.response.statusCode == 401) {
        print({"status": false, "message": e.response.data['message']});
        return {"status": false, "message": e.response.data['message']};
      }
    }
  }

  // ignore: missing_return
  Future<bool?> fetchContentManagement() async {
    try {
      String url = "$baseUrl/public/pages/customer/pandp";
      print(url);
      final result = await APIRequest().get(myUrl: url, token: auth!.token);
      print("result $result");

      String title = result.data['data']['title'];
      String body = result.data['data']['body'];
      String slug = result.data['data']['slug'];

      List<ContentManagementModel> loadContentManagement = [];

      (result.data['data'] as List).forEach((notify) {
        loadContentManagement.add(ContentManagementModel.fromJson(notify));
      });
      contentManagement!.addAll(loadContentManagement);

      notifyListeners();
      return true;
    } on DioError catch (e, s) {
      print(s);
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
      // return [
      //   {"status": false, "message": e.response}
      // ];
    }
  }
}

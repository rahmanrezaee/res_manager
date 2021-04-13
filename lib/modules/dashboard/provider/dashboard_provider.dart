import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DashboardProvider with ChangeNotifier {
  var _dashboardData;
  AuthProvider auth;

  DashboardProvider(this.auth);
  get getDashData => _dashboardData;

  fetchDashData() async {
    // if (token == '') {
    String url = "$baseUrl/admin/restaurant/dashboard";
    var res = await APIRequest().get(myUrl: url, token: auth.token);
    this._dashboardData = res.data['data'];
    print(_dashboardData);
    notifyListeners();
    // }
  }
}

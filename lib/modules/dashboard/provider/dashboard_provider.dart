import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DashboardProvider with ChangeNotifier {
  var _dashboardData;
  get getDashData => _dashboardData;

  fetchDashData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = json.decode(prefs.getString("user"))['token'];
    // if (token == '') {
    String url = "$baseUrl/admin/restaurant/dashboard";
    var res = await APIRequest().get(myUrl: url, token: token);
    this._dashboardData = res.data['data'];
    print(_dashboardData);
    notifyListeners();
    // }
  }
}

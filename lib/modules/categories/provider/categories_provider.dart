import 'package:admin/modules/categories/models/categorie_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CategoryProvider with ChangeNotifier {
  ///
  List<CategoryModel> _categories;
  get getCategories => _categories;

  ///
  fetchCustomers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = json.decode(prefs.getString("user"))['token'];
    String url = "$baseUrl/admin/food/603f313fd0c6141040de8c89";
    var res = await APIRequest().get(myUrl: url, token: token);
    this._categories = [];
    (res.data['data'] as List).forEach((category) {
      this._categories.add(new CategoryModel.fromJson(category));
    });
    notifyListeners();
  }

  //add Category
  Future addNewCategory(String resId, String newCategory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = json.decode(prefs.getString("user"))['token'];
    print(token);
    String url = "$baseUrl/restaurant/category";
    var res = await APIRequest().post(
      myUrl: url,
      myBody: {"restaurantId": resId, "categoryName": newCategory},
      myHeaders: {
        "token": token,
      },
    );
    notifyListeners();
    return res.data;
  }

  //Edit category
  Future editCategory(catId, resId, category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = json.decode(prefs.getString("user"))['token'];
    String url = "$baseUrl/restaurant/category/$catId";
    var res = await APIRequest().put(
      myUrl: url,
      myBody: {
        "restaurantId": resId,
        "categoryName": category,
      },
      myHeaders: {
        "token": token,
      },
    );
  }
}

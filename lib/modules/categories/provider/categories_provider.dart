import 'package:admin/modules/categories/models/categorie_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/restaurant_model.dart';

class CategoryProvider with ChangeNotifier {
  ///cat List
  List<CategoryModel> _categories;
  get getCategories => _categories;

  ///res List
  List<RestaurantModel> _restaurants;
  List<RestaurantModel> get getRestaurant => _restaurants;

  fetchCategories(String resId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = json.decode(prefs.getString("user"))['token'];
    String url = "$baseUrl/admin/food/$resId";
    var res = await APIRequest().get(myUrl: url, token: token);
    this._categories = [];
    (res.data['data'] as List).forEach((category) {
      print("thsi is the single cat: $category");
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
  Future<Map> editCategory(catId, resId, category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = json.decode(prefs.getString("user"))['token'];
    String url = "$baseUrl/public/category/$catId";
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

    print(res.data);
    notifyListeners();
    return res.data;
  }

  Future fetchRes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = json.decode(prefs.getString("user"))['token'];
    String url = "$baseUrl/admin/restaurant";
    var res = await APIRequest().get(myUrl: url, token: token);
    this._restaurants = [];
    (res.data['data'] as List).forEach((res) {
      this._restaurants.add(new RestaurantModel.fromJson(res));
    });
    notifyListeners();
    return true;
  }

  deleteCategoy(categryId) async {
    //getting token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = json.decode(prefs.getString("user"))['token'];
    //getting data
    String url = "$baseUrl/public/category/$categryId";
    var res = await APIRequest()
        .delete(myUrl: url, myBody: null, myHeaders: {'token': token});
    print(res.data);
    notifyListeners();
    return res.data;
  }
}

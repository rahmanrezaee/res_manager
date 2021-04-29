import 'dart:developer';

import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/categories/models/categorie_model.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/restaurant_model.dart';

class CategoryProvider with ChangeNotifier {
  ///cat List

  AuthProvider auth;
  List<CategoryModel> _categories;

  CategoryProvider(this.auth);
  get getCategories => _categories;
  String resturantId;

  setCategoryToNull() {
    _categories = null;
    notifyListeners();
  }

  setResturantId(resId) {
    this.resturantId = resId;
    notifyListeners();
  }

  ///res List
  List<RestaurantModel> _restaurants;
  List<RestaurantModel> get getRestaurant => _restaurants;
  String get getRestaurantId => resturantId;

  fetchCategories() async {
    try {
      String url = "$baseUrl/admin/food/$resturantId";
      var res = await APIRequest().get(
        myUrl: url,
        token: auth.token,
      );
      this._categories = [];
      (res.data['data'] as List).forEach((category) {
        print("thsi is the single cat: $category");
        this._categories.add(new CategoryModel.fromJson(category));
      });
      notifyListeners();
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  //add Category
  Future addNewCategory(String resId, String newCategory) async {
    try {
      String url = "$baseUrl/restaurant/category";
      Map data = {"restaurantId": resId, "categoryName": newCategory};
      log("category Data $data");
      var res = await APIRequest().post(
        myUrl: url,
        myBody: data,
        myHeaders: {
          "token": auth.token,
        },
      );

      this._categories = null;
      notifyListeners();
      return res.data;
    } on DioError catch (e) {
      print("error ${e.response}");
    }
  }

  //Edit category
  Future<Map> editCategory(catId, resId, category) async {
    String url = "$baseUrl/public/category/$catId";
    var res = await APIRequest().put(
      myUrl: url,
      myBody: {
        "restaurantId": resId,
        "categoryName": category,
      },
      myHeaders: {
        "token": auth.token,
      },
    );
    this._categories = null;
    print(res.data);
    notifyListeners();
    return res.data;
  }

  Future fetchRes() async {
    String url = "$baseUrl/admin/restaurant";
    var res = await APIRequest().get(
      myUrl: url,
      token: auth.token,
    );
    this._restaurants = [];
    (res.data['data'] as List).forEach((res) {
      this._restaurants.add(new RestaurantModel.fromJson(res));
    });
    notifyListeners();
    return true;
  }

  deleteCategoy(categryId) async {
    //getting token

    //getting data
    String url = "$baseUrl/public/category/$categryId";
    var res = await APIRequest().delete(myUrl: url, myBody: null, myHeaders: {
      'token': auth.token,
    });
    this._categories = null;
    notifyListeners();
    return res.data;
  }
}

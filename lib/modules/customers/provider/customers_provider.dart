import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/customer_model.dart';
import '../models/order_model.dart';
import '../models/review_model.dart';

class CustomersProvider with ChangeNotifier {
  ///
  List<Customer> _customers;
  List<Customer> get getCustomers => _customers;
  bool loadingMore;
  bool hasMoreItems;
  int maxItems;
  int page = 1;
  int lastPage;

  ///
  Customer _customer;
  Customer get getCustomer => _customer;

  ///
  List<OrderModel> _orders;
  get getOrders => _orders;

  ///
  List<ReviewModel> _reviews;
  List<ReviewModel> get getReview => _reviews;

  //
  // int page = 1;
  // int limit = 10;
  Future<bool> fetchCustomers() async {
    try {
      String url = "$baseUrl/admin/user/customer?page=$page";
      final result =
          await APIRequest().get(myUrl: url, token: await AuthProvider().token);

      print("result $result");

      maxItems = result.data['data']['totalDocs'];
      page = result.data['data']['page'];
      lastPage = result.data['data']['totalPages'];
      print("result $lastPage");

      if (page == lastPage) {
        hasMoreItems = false;
      } else {
        hasMoreItems = true;
      }

      List<Customer> loadedProducts = [];

      (result.data['data']['data'] as List).forEach((notify) {
        loadedProducts.add(Customer.fromJson(notify));
      });

      if (this._customers == null) {
        this._customers = [];
      }
      this._customers.addAll(loadedProducts);
      page++;

      notifyListeners();
      return true;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }

    // var res =
    //     await APIRequest().get(myUrl: url, token: await AuthProvider().token);
    // if (this._customers == null) {
    //   this._customers = [];
    // }
    // if ((res.data['data']['data'] as List).length > 0) {
    //   (res.data['data']['data'] as List).forEach((element) {
    //     Customer newCustomer = new Customer(
    //       id: element['user']['_id'],
    //       username: element['user']['username'],
    //       activeOrders: element['activeOrders'],
    //     );
    //     this._customers.add(newCustomer);
    //   });
    // }
    // notifyListeners();
    // return _customers;
  }

  fetchCustomer(String customerId) async {
    //getting data
    String url = "$baseUrl/admin/user/customer/$customerId";
    var res =
        await APIRequest().get(myUrl: url, token: await AuthProvider().token);
    //getting user data
    var userJson = res.data['data']['userData'];
    userJson['totalOrder'] = (res.data['data']['orders'] as List).length;
    this._customer = new Customer.fromJson(userJson);
    //getting user orders
    print(res.data['data']['orders']);
    this._orders = [];
    (res.data['data']['orders'] as List).forEach((order) {
      order['customerName'] = res.data['data']['userData']['username'];
      this._orders.add(new OrderModel.fromJson(order));
    });
    //getting user review
    this._reviews = [];
    (res.data['data']['review'] as List).forEach((review) {
      // order['customerName'] = res.data['data']['userData']['username'];
      this._reviews.add(new ReviewModel.fromJson(review));
    });

    notifyListeners();
  }

  deleteCustomer(customerId) async {
    try {
      String url = "$baseUrl/admin/user/customer/$customerId";
      var res = await APIRequest().delete(
          myUrl: url,
          myBody: null,
          myHeaders: {'token': await AuthProvider().token});

      print("res $res");
      _customers = null;
      page = 1;
      notifyListeners();
      return res.data;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  void nullList() {
    _customers = null;
    notifyListeners();
  }

  showLoadingBottom(bool state) {
    loadingMore = state;
    notifyListeners();
  }
}

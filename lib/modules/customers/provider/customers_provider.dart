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

  AuthProvider auth;

  CustomersProvider(this.auth);
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
  Future<bool> fetchCustomers({pageInit}) async {
    try {
      int currrentPage = page;
      if (pageInit != null) {
        currrentPage = pageInit;
        _customers = null;
      }
      String url = "$baseUrl/admin/user/customer?page=$currrentPage";
      final result = await APIRequest().get(myUrl: url, token: auth.token);

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
    //     await APIRequest().get(myUrl: url, token: auth.token);
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

  Future<Map> fetchCustomer(String customerId) async {
    //getting data
    String url = "$baseUrl/admin/user/customer/$customerId";
    var res = await APIRequest().get(myUrl: url, token: auth.token);
    //getting user data
    var userJson = res.data['data'];

    Customer customerData = new Customer.fromComplateJson(userJson);

    List<OrderModel> _ordersCustomer = [];
    (userJson['orders'] as List).forEach((order) {
      order['customerName'] = userJson['userData']['username'];
      _ordersCustomer.add(new OrderModel.fromJson(order));
    });
    //getting user review
    List<ReviewModel> _reviewsCustomer = [];
    (userJson['review'] as List).forEach((review) {
      _reviewsCustomer.add(new ReviewModel.fromJson(review));
    });

    return {
      "customer": customerData,
      "ordersCustomer": _ordersCustomer,
      "reviewsCustomer": _reviewsCustomer
    };
  }

  deleteCustomer(customerId) async {
    try {
      String url = "$baseUrl/admin/user/customer/$customerId";
      var res = await APIRequest()
          .delete(myUrl: url, myBody: null, myHeaders: {'token': auth.token});

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
    page = 1;
    notifyListeners();
  }

  showLoadingBottom(bool state) {
    loadingMore = state;
    notifyListeners();
  }
}

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
  get getCustomers => _customers;

  ///
  Customer _customer;
  Customer get getCustomer => _customer;

  ///
  List<OrderModel> _orders;
  get getOrders => _orders;

  ///
  List<ReviewModel> _reviews;
  List<ReviewModel> get getReview => _reviews;

  ///
  fetchCustomers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = json.decode(prefs.getString("user"))['token'];
    String url = "$baseUrl/admin/user/customer";
    var res = await APIRequest().get(myUrl: url, token: token);
    (res.data['data'] as List).forEach((element) {
      this._customers = [];
      print(element);
      Customer newCustomer = new Customer(
        id: element['user']['_id'],
        username: element['user']['username'],
        activeOrders: element['activeOrders'],
      );
      this._customers.add(newCustomer);
    });
    notifyListeners();
  }

  fetchCustomer(String customerId) async {
    //getting token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = json.decode(prefs.getString("user"))['token'];
    //getting data
    String url = "$baseUrl/admin/user/customer/$customerId";
    var res = await APIRequest().get(myUrl: url, token: token);
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
}

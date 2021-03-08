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
  get getCustomer => _customer;

  ///
  List<OrderModel> _orders;
  get getOrders => _orders;

  ///
  List<ReviewModel> _reviews;
  get getReview => _reviews;

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
    print("customerId: $customerId");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = json.decode(prefs.getString("user"))['token'];
    String url = "$baseUrl/admin/user/customer/$customerId";
    var res = await APIRequest().get(myUrl: url, token: token);
    print(res.data);
    notifyListeners();
  }
}

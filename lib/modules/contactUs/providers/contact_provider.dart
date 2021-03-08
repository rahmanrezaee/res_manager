import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/api_path.dart';
import 'package:admin/modules/contactUs/model/contact_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ContactProvider with ChangeNotifier {
  List<ContactModel> contacts;
  List<ContactModel> get getContacts => this.contacts;
  fetchContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = json.decode(prefs.getString("user"))['token'];
    String url = "$baseUrl/admin/contact";
    var res = await APIRequest().get(myUrl: url, token: token);
    this.contacts = [];
    (res.data['data'] as List).forEach((contact) {
      print(contact);
      contacts.add(new ContactModel.fromJson(contact));
    });

    notifyListeners();
  }
}

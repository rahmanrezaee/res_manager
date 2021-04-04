import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/contactUs/model/contact_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ContactProvider with ChangeNotifier {
  List<ContactModel> contacts;
  List<ContactModel> get getContacts => this.contacts;

  Future<List<ContactModel>> fetchContacts(int pageKey, pageSize) async {
    print("pageKey");
    int page = (pageKey / 10).round();
    try {
      String url = "$baseUrl/admin/contact?page=$page&limit=10";
      print(url);
      final result =
          await APIRequest().get(myUrl: url, token: await AuthProvider().token);
      print("result $result");
      final extractedData = result.data["data"]['docs'];
      if (contacts == null) {
        contacts = [];
      }
      print("result $result");
      final List<ContactModel> loadedProducts = [];
      if (extractedData.length > 0) {
        extractedData.forEach((tableData) {
          contacts.add(ContactModel.fromJson(tableData));
        });
      }
      // contacts = loadedProducts;
      notifyListeners();
      return this.contacts;
    } on DioError catch (e, s) {
      print(s);
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
      // return [
      //   {"status": false, "message": e.response}
      // ];
    }
  }
}

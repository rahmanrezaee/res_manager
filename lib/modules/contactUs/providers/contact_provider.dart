import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/contactUs/model/contact_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ContactProvider with ChangeNotifier {
  List<ContactModel> ? contacts;
  AuthProvider auth;

  ContactProvider(this.auth);
  List<ContactModel> get getContacts => this.contacts!;
  bool ? loadingMore;
  bool ? hasMoreItems;
  int ? maxItems;
  int page = 1;
  int ? lastPage;

  showLoadingBottom(bool state) {
    loadingMore = state;
    notifyListeners();
  }

  Future<bool?> fetchContacts() async {
    try {
      String url = "$baseUrl/admin/contact?page=$page";
      print(url);
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

      List<ContactModel> loadedProducts = [];

      (result.data['data']['docs'] as List).forEach((notify) {
        loadedProducts.add(ContactModel.fromJson(notify));
      });

      if (contacts == null) {
        contacts = [];
      }
      contacts!.addAll(loadedProducts);
      page++;

      notifyListeners();
      return true;
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

  void setPage(int i) {
    page = i;
    contacts = null;
    notifyListeners();
  }
}

import 'dart:developer';

// import 'package:DoctorProject/Const/variables.dart';
// import 'package:DoctorProject/Models/HospitalModel.dart';
// import 'package:DoctorProject/Providers/auth_provider.dart';
import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/coupons/model/CouponModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CoupenProvider with ChangeNotifier {
  List<CouponModel> list;
  AuthProvider auth;
  bool loadingMore;
  bool hasMoreItems;
  int maxItems;
  int page = 1;
  int lastPage;

  CoupenProvider(this.auth);

  showLoadingBottom(bool state) {
    loadingMore = state;
    notifyListeners();
  }

  void setPage(int i) {
    page = i;
    list = null;
    notifyListeners();
  }

  Future<CouponModel> getSingleCoupen(id) async {
    try {
      String url = "$baseUrl/admin/coupon/$id";

      final result = await APIRequest().get(myUrl: url, token: auth.token);

      print("result $result");

      final extractedData = result.data["data"];

      if (extractedData == null) {
        return null;
      }

      return Future.value(CouponModel.toComplateJson(extractedData));
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future<bool> getCoupenList() async {
    try {
      String url = "$baseUrl/admin/coupon?page=$page";

      final result = await APIRequest().get(myUrl: url, token: auth.token);

      maxItems = result.data['data']['totalDocs'];
      page = result.data['data']['page'];
      lastPage = result.data['data']['totalPages'];
      print("result $lastPage");

      if (page == lastPage) {
        hasMoreItems = false;
      } else {
        hasMoreItems = true;
      }

      List<CouponModel> loadedProducts = [];

      (result.data['data']['docs'] as List).forEach((notify) {
        loadedProducts.add(CouponModel.toJson(notify));
      });

      if (list == null) {
        list = [];
      }
      list.addAll(loadedProducts);
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
  }

  Future addCoupen(data) async {
    print("da $data");
    try {
      final StringBuffer url = new StringBuffer("$baseUrl/admin/coupon");
      print(url.toString());

      final response = await APIRequest().post(
        myBody: data,
        myHeaders: {
          "token": auth.token,
        },
        myUrl: url.toString(),
      );

      final extractedData = response.data;
      print("franch data 1 $extractedData ");
      setPage(1);
      // listResturant.add(ResturantModel.toJson(extractedData));

      notifyListeners();
      return extractedData;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
      return e.response.data;
    }
  }

  Future editCoupen(data, id) async {
    print("da $data");
    try {
      final StringBuffer url = new StringBuffer("$baseUrl/admin/coupon/$id");
      print(url.toString());

      final response = await APIRequest().put(
        myBody: data,
        myHeaders: {"token": auth.token},
        myUrl: url.toString(),
      );

      final extractedData = response.data;
      print("franch data 1 $extractedData ");

      setPage(1);

      notifyListeners();
      return extractedData;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
      return e.response.data;
    }
  }

  Future<bool> deleteCoupen(id) async {
    try {
      String url = "$baseUrl/admin/coupon/$id";
      var res = await APIRequest()
          .delete(myUrl: url, myBody: null, myHeaders: {'token': auth.token});

      setPage(1);
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
      return false;
    }
  }

  // List<CouponModel> coupenList;

  // bool hasMoreItems = true;
  // bool loadingMore;
  // int maxItems;
  // int page = 1;
  // int lastPage;

  // String search = "";

  // void setSearch(String t) {
  //   this.search = t;
  //   notifyListeners();
  // }

  // void setPage(int t) {
  //   this.page = t;
  //   notifyListeners();
  // }

  // Dio dio = new Dio();

  // showLoadingBottom(bool state) {
  //   loadingMore = state;
  //   notifyListeners();
  // }

  // void clearToNullList() {
  //   hasMoreItems = null;
  //   loadingMore = null;
  //   maxItems = null;
  //   page = 1;
  //   notifyListeners();
  // }

  // // Future<bool> getCoupenList() async {
  // //   try {
  // //     String url =
  // //         "$BASE_URL/hospital/list?page=$page&type=$type&search=$search";

  // //     final extractedData = result.data["data"];
  // //     log("data $extractedData");
  // //     if (extractedData == null) {
  // //       healthInfos = [];
  // //       return false;
  // //     }
  // //     maxItems = result.data['meta']['total'];
  // //     page = result.data['meta']['current_page'];
  // //     lastPage = result.data['meta']['last_page'];

  // //     if (page == lastPage) {
  // //       hasMoreItems = false;
  // //     } else {
  // //       hasMoreItems = true;
  // //     }

  // //     List<HospitalModel> loadedProducts = [];

  // //     extractedData.forEach((tableData) {
  // //       loadedProducts.add(HospitalModel.fromJson(tableData));
  // //       print(tableData["data"]);
  // //       print("////////${auth.token}");
  // //     });
  // //     if (healthInfos == null) {
  // //       healthInfos = [];
  // //     }
  // //     healthInfos.addAll(loadedProducts);
  // //     page++;
  // //     notifyListeners();
  // //     return true;
  // //   } on DioError catch (e) {
  // //     print("Mahdi: getFranchies: Error ${e.request}");
  // //     print("Mahdi: getFranchies: Error ${e.message}");
  // //     print("Mahdi: getFranchies: Error ${e.response}");
  // //   }
  // // }
}

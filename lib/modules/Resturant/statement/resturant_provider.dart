import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Resturant/Models/Resturant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ResturantProvider with ChangeNotifier {
  List<ResturantModel> listResturant;

  Future<bool> getResturantList() async {
    try {
      String url = "$baseUrl/admin/restaurant";

      final result = await APIRequest().get(myUrl: url, token: token);

      print("result $result");

      final extractedData = result.data["data"];

      if (extractedData == null) {
        listResturant = [];
        return false;
      }

      final List<ResturantModel> loadedProducts = [];

      extractedData.forEach((tableData) {
        loadedProducts.add(ResturantModel.toJson(tableData));
      });

      listResturant = loadedProducts;

      print(listResturant);

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

  Future<bool> addResturant(data) async {
    print("da $data");
    try {
      final StringBuffer url = new StringBuffer("$baseUrl/admin/restaurant");
      print(url.toString());

      final response = await APIRequest().post(
        myBody: data,
        myHeaders: {
          "token": token,
        },
        myUrl: url.toString(),
      );

      final extractedData = response.data["data"];
      print("franch data 1 $extractedData ");

      listResturant = null;
      // listResturant.add(ResturantModel.toJson(extractedData));

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
}

import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Resturant/Models/Resturant.dart';
import 'package:flutter/cupertino.dart';

class ResturantProvider with ChangeNotifier {
  List<ResturantModel> listResturant;

  Future<bool> getResturantList() async {
    try {
      String url = "$baseUrl/admin/restaurant";

      
     

      final result = await APIRequest().get(myUrl: url, token: "");

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

        notifyListeners();
    
      return true;
    } catch (e) {
      print("Mahdi: getFranchies: Error $e");
    }
  }
}

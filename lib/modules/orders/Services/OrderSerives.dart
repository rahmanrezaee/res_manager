import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/orders/Models/OrderModels.dart';
import 'package:dio/dio.dart';

class OrderServices {
  Future<List<OrderModels>> getAllOrder({state}) async {
    List<OrderModels> listOrder;
    try {
      String url = "$baseUrl/admin/order?status=$state";

      final result = await APIRequest().get(myUrl: url, token: await gettoken());

      final extractedData = result.data["data"];

      if (extractedData == null) {
        listOrder = [];
        return listOrder;
      }

      final List<OrderModels> loadedOrder = [];
      int i = 0;
      extractedData.forEach((tableData) {
        i++;

        print("elements $i");
        loadedOrder.add(OrderModels.toJson(tableData));
      });

      listOrder = loadedOrder;

      return loadedOrder;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future<List<OrderModels>> getSingleOrder({state, resturantId}) async {
    List<OrderModels> listOrder;
    try {
      String url = "$baseUrl/admin/order/${resturantId}?status=$state";

      final result = await APIRequest().get(myUrl: url, token: await gettoken());

      print("result $result");

      final extractedData = result.data["data"];

      if (extractedData == null) {
        listOrder = [];
        return listOrder;
      }

      final List<OrderModels> loadedOrder = [];

      extractedData.forEach((tableData) {
        loadedOrder.add(OrderModels.toJson(tableData));
      });

      listOrder = loadedOrder;

      return loadedOrder;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future<bool> pickup(orderId, statue) async {
    try {
      String url = "$baseUrl/admin/order/$orderId";

      final result = await APIRequest().post(
          myUrl: url, myHeaders: {"token": await gettoken()}, myBody: {"status": statue});

      print("result $result");
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

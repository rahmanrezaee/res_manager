import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/dishes/Models/dishModels.dart';
import 'package:dio/dio.dart';

Future<DishModel> getSingleDish(id) async {
  try {
    String url = "$baseUrl/admin/food/view/$id";

    final result =
        await APIRequest().get(myUrl: url, token: await AuthProvider().token);

    print("result $result");

    final extractedData = result.data["data"];

    if (extractedData == null) {
      return null;
    }

    return Future.value(DishModel.toComplateJson(extractedData));
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}

Future<List<DishModel>> getFootListWithoutPro(catId) async {
  try {
    String url = "$baseUrl/admin/food/category/$catId";

    final result =
        await APIRequest().get(myUrl: url, token: await AuthProvider().token);

    print("result $result");

    final extractedData = result.data["data"]['foods']['docs'];

    List<DishModel> loadedProducts = [];

    extractedData.forEach((tableData) {
      loadedProducts.add(DishModel.toCatJson(tableData));
    });

    return loadedProducts;
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}

Future addDishService(data) async {
  print("da $data");
  try {
    final StringBuffer url = new StringBuffer("$baseUrl/admin/food");
    print(url.toString());

    final response = await APIRequest().post(
      myBody: data,
      myHeaders: {
        "token": await AuthProvider().token,
      },
      myUrl: url.toString(),
    );

    final extractedData = response.data;
    print("franch data 1 $extractedData ");

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

Future editDishService(data, id) async {
  print("da $data");
  try {
    final StringBuffer url = new StringBuffer("$baseUrl/admin/food/$id");
    print(url.toString());

    final response = await APIRequest().put(
      myBody: data,
      myHeaders: {
        "token": await AuthProvider().token,
      },
      myUrl: url.toString(),
    );

    final extractedData = response.data;
    print("franch data 1 $extractedData ");

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

Future<bool> deleteDish(foodId) async {
  try {
    //getting token

    String url = "$baseUrl/admin/food/$foodId";
    var res = await APIRequest().delete(
        myUrl: url,
        myBody: null,
        myHeaders: {'token': await AuthProvider().token});

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

Future<bool> changeVisiablity(foodId, vis) async {
  try {
    String url = "$baseUrl/admin/food/changevisibility/$foodId";

    final result = await APIRequest().post(
        myUrl: url,
        myHeaders: {"token": await AuthProvider().token},
        myBody: {"visibility": vis});

    print("result $result");

    return result.data['status'];
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}

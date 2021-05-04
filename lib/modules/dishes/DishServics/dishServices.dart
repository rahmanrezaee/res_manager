import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/customers/models/review_model.dart';
import 'package:admin/modules/dishes/Models/dishModels.dart';
import 'package:dio/dio.dart';

Future<Map> getSingleDish(id, AuthProvider auth) async {
  try {
    String url = "$baseUrl/admin/food/view/$id";

    final result = await APIRequest().get(myUrl: url, token: auth.token);

    print("result $result");

    final extractedData = result.data["data"];

    if (extractedData == null) {
      return null;
    }

    //getting user review
    List<ReviewModel> _reviewsCustomer = [];
    (extractedData['review'] as List).forEach((review) {
      _reviewsCustomer.add(new ReviewModel.fromJson(review));
    });

    return Future.value({
      "dish": DishModel.toComplateJson(extractedData),
      "review": _reviewsCustomer
    });
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}

Future<List<DishModel>> getFootListWithoutPro(catId, AuthProvider auth) async {
  try {
    String url = "$baseUrl/admin/food/category/$catId";

    final result = await APIRequest().get(myUrl: url, token: auth.token);

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

Future addDishService(data, AuthProvider auth) async {
  print("da $data");
  try {
    final StringBuffer url = new StringBuffer("$baseUrl/admin/food");
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

Future editDishService(data, id, AuthProvider auth) async {
  print("da $data");
  try {
    final StringBuffer url = new StringBuffer("$baseUrl/admin/food/$id");
    print(url.toString());

    final response = await APIRequest().put(
      myBody: data,
      myHeaders: {
        "token": auth.token,
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

Future deleteDish(foodId, AuthProvider auth) async {
  try {
    //getting token

    String url = "$baseUrl/admin/food/food/$foodId";
    var res = await APIRequest()
        .delete(myUrl: url, myBody: null, myHeaders: {'token': auth.token});
    print("delete of dish ${res.data}");
    return res.data;
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
    return e.response.data;
  }
}

Future<bool> changeVisiablity(foodId, vis, AuthProvider auth) async {
  try {
    String url = "$baseUrl/admin/food/changevisibility/$foodId";

    final result = await APIRequest().post(
        myUrl: url,
        myHeaders: {"token": auth.token},
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

import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:dio/dio.dart';

Future<double> getEarningReport({fromDate, toDate, resId}) async {
  try {
    String url =
        "$baseUrl/admin/report?fromDate=$fromDate&toDate=$toDate&restaurantId=$resId";

    final result =
        await APIRequest().get(myUrl: url, token: await AuthProvider().token);

    print("result $result");

    final extractedData = result.data["data"];
    return double.parse("${extractedData}");
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}

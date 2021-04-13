import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:dio/dio.dart';

Future getReport({fromDate, toDate, type, coupenCode, restaurantId,AuthProvider auth}) async {
  try {
    String url =
        "$baseUrl/admin/report/orders?type=$type${coupenCode != null && coupenCode != "" ? "&couponCode=" + coupenCode : ""}${restaurantId != null && restaurantId != "" && restaurantId == "none" ? "&restaurantId=" + restaurantId : ""}${fromDate != null ? "&fromDate=" + fromDate : ""}${toDate != null ? "&toDate=" + toDate : ""}";

    final result = await APIRequest().get(myUrl: url, token: auth.token);

    print("result $result");
    if (type == "earnings") {
      return result.data["data"]['totalEarning'];
    } else {
      return result.data["data"]['ordersQuantity'];
    }
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}

Future getSendReportEmil({fromDate, toDate, coupenCode,AuthProvider auth}) async {
  try {
    String url = "$baseUrl/restaurant/report/email-report-orders";

    Map data = {};

    if (fromDate != null) {
      data = {
        "fromDate": fromDate,
      };
    }
    if (toDate != null) {
      data = {
        "toDate": toDate,
      };
    }
    if (coupenCode != null) {
      data = {
        "couponCode": coupenCode,
      };
    }

    print(data);
    final result = await APIRequest()
        .post(myUrl: url, myHeaders: {"token": auth.token}, myBody: data);

    print("result $result");

    final extractedData = result.data["data"];
    return extractedData;
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}

Future getSendReportEmailEarnings({fromDate, toDate,AuthProvider auth}) async {
  try {
    String url = "$baseUrl/restaurant/report/email-report-earnings";

    Map data = {};

    if (fromDate != null) {
      data = {
        "fromDate": fromDate,
      };
    }
    if (toDate != null) {
      data = {
        "toDate": toDate,
      };
    }

    print(data);
    final result = await APIRequest()
        .post(myUrl: url, myHeaders: {"token": auth.token}, myBody: data);

    print("result $result");

    final extractedData = result.data["data"];
    return extractedData;
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}

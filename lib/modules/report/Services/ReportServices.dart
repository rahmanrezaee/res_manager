import 'dart:developer';

import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:dio/dio.dart';

Future getReport(
    {fromDate,
    toDate,
    type,
    coupenCode,
    restaurantId,
    AuthProvider? auth}) async {
  try {
    print(
        "params fromDate $fromDate toDate $toDate coupenCode $coupenCode restaurantId $restaurantId");
    String url =
        "$baseUrl/admin/report/orders?type=$type${coupenCode != null && coupenCode != "" ? "&couponCode=" + coupenCode : ""}${restaurantId == null || restaurantId == "" || restaurantId == "none" ? "" : "&restaurantId=" + restaurantId}${fromDate != null ? "&fromDate=" + fromDate : ""}${toDate != null ? "&toDate=" + toDate : ""}";

    final result = await APIRequest().get(myUrl: url, token: auth!.token);

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

Future getSendReportEmil(
    {fromDate,
    toDate,
    resturant,
    coupenCode,
    AuthProvider ?auth,
    String ?totalUser,
    String ?restaurantId}) async {
  try {
    String url = "$baseUrl/restaurant/report/email-report-orders";
    print("url $url");
    Map data = {};
    if (coupenCode != null && coupenCode != "") {
      data['Coupon Code'] = coupenCode;
    }
    if (resturant != null) {
      data['restaurantId'] = resturant;
    }

    if (fromDate != null) {
      data['From Date'] = fromDate;
    }
    if (toDate != null) {
      data['To Date'] = toDate;
    }

    if (totalUser != null) {
      data['Total Order Userd Coupon'] = totalUser;
    }
    print("this is email report");
    print(data);
    final result = await APIRequest()
        .post(myUrl: url, myHeaders: {"token": auth!.token}, myBody: data);

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

Future getSendReportEmailEarnings(
    {fromDate, toDate, resturant, AuthProvider? auth, String? earning}) async {
  try {
    String url = "$baseUrl/restaurant/report/email-report-earnings";
    print("url $url");
    Map data = {};

    if (fromDate != null) {
      data['From Date'] = fromDate;
    }
    if (resturant != null) {
      data['restaurantId'] = resturant;
    }
    if (toDate != null) {
      data['To Date'] = toDate;
    }
    if (earning != null) {
      data['Total Earning'] = earning;
    }

    log("data $data");
    final result = await APIRequest()
        .post(myUrl: url, myHeaders: {"token": auth!.token}, myBody: data);

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

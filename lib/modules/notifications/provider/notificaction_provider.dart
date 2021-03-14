import 'package:admin/constants/api_path.dart';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/notifications/models/notification_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  var dio = Dio();
  List<NotificationModel> notificatins;
  fetchNotifications() async {
    Response response = await dio.get('$baseUrl/public/notification',
        options: new Options(headers: {'token': await AuthProvider().token}));
    notificatins = [];
    (response.data['data'] as List).forEach((notify) {
      NotificationModel not = new NotificationModel.fromJson(notify);
      notificatins.add(not);
    });

    notifyListeners();
  }
}

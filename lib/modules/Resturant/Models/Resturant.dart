import 'package:admin/modules/Resturant/Models/TimeModel.dart';
import 'package:admin/modules/Resturant/Models/location.dart';

class ResturantModel {
  String resturantName;
  String id;
  LocationModel location;
  TimeModel sunday;
  TimeModel monday;
  TimeModel tuesday;
  TimeModel wednesday;
  TimeModel thursday;
  TimeModel friday;
  TimeModel saturday;
  String email;
  String password;
  int activeOrder;

  ResturantModel.toJson(tableData) {
    this.resturantName = tableData['restaurant']['username'];
    this.id = tableData['restaurant']['_id'];
    this.activeOrder = tableData['activeOrder'];
  }
}

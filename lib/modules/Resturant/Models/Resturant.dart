import 'package:admin/modules/Resturant/Models/TimeModel.dart';
import 'package:admin/modules/Resturant/Models/location.dart';

class ResturantModel {
  String resturantName;
  String avatar;
  String id;
  LocationModel location;
  TimeModel sunday = TimeModel();
  TimeModel monday = TimeModel();
  TimeModel tuesday = TimeModel();
  TimeModel wednesday = TimeModel();
  TimeModel thursday = TimeModel();
  TimeModel friday = TimeModel();
  TimeModel saturday = TimeModel();
  String email;
  String password;
  int activeOrder;

  ResturantModel();

  ResturantModel.toJson(tableData) {
    this.resturantName = tableData['restaurant']['username'];
    this.id = tableData['restaurant']['_id'];
    this.activeOrder = tableData['activeOrder'];
  }

  Map sendMap() {
    return {
      "username": this.resturantName,
      "avatar": this.avatar,
      "location": {
        "type": "Point",
        "coordinates": [this.location.lat, this.location.log]
      },
      "Sunday": {
        "time": [this.sunday.startTime, this.sunday.endTime]
      },
      "Monday": {
        "time": [this.monday.startTime, this.monday.endTime]
      },
      "Tuesday": {
        "time": [this.tuesday.startTime, this.tuesday.endTime]
      },
      "Wednesday": {
        "time": [this.wednesday.startTime, this.wednesday.endTime]
      },
      "Thursday": {
        "time": [this.thursday.startTime, this.thursday.endTime]
      },
      "Friday": {
        "time": [this.friday.startTime, this.friday.endTime]
      },
      "Saturday": {
        "time": [this.saturday.startTime, this.saturday.endTime]
      },
      "email": this.email,
      "password": this.password
    };
  }
}

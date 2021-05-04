import 'package:admin/modules/customers/models/customer_model.dart';

class ReviewModel {
  String id;
  Customer userId;
  double rate;
  String date;
  String message;
  ReviewModel({this.id, this.userId, this.rate, this.message, this.date});

  factory ReviewModel.fromJson(Map json) {
    try {
      return ReviewModel(
        id: json['_id'],
        userId: new Customer.fromDishJson(json['userId']),
        rate: double.parse(json['rate'].toString()),
        message: json['message'],
        date: json['createdAt'],
      );
    } catch (e) {
      print("error review: $e");
    }
  }
}

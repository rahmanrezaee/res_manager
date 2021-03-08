import 'package:admin/modules/customers/models/customer_model.dart';

class ReviewModel {
  String id;
  Customer userId;
  int rate;
  String message;
  ReviewModel({this.id, this.userId, this.rate, this.message});

  factory ReviewModel.fromJson(Map json) {
    return ReviewModel(
      id: json['_id'],
      userId: new Customer.fromJson(json['userId']),
      rate: json['rate'],
      message: json['message'],
    );
  }
}

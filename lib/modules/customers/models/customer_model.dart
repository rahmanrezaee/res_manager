import 'package:json_annotation/json_annotation.dart';

part 'customer_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer {
  String id;
  int activeOrders;
  String username;
  Map avatar;
  String email;
  Customer({
    this.id,
    this.username,
    this.activeOrders,
    this.avatar,
    this.email,
  });
  factory Customer.fromJson(Map json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

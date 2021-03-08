import './orderItem_model.dart';

class OrderModel {
  String id;
  String status;
  String restaurantId;
  String userId;
  int totalItems;
  List<OrderItem> items;
  double totalPrice;
  int restaurantCharges;
  int grandTotal;
  String cardName;
  String createdAt;
  String updatedAt;
  OrderModel({
    this.id,
    this.status,
    this.restaurantId,
    this.userId,
    this.totalItems,
    this.items,
    this.totalPrice,
    this.restaurantCharges,
    this.grandTotal,
    this.cardName,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(json) {
    List<OrderItem> items = [];
    (json['items'] as List).forEach((order) {
      items.add(OrderItem.fromJson(order));
    });

    return new OrderModel(
      id: json['id'],
      status: json['status'],
      restaurantId: json['restaurantId'],
      userId: json['userId'],
      totalItems: json['totalItems'],
      items: items,
      totalPrice: json['totalPrice'],
      restaurantCharges: json['restaurantCharges'],
      grandTotal: json['grandTotal'],
      cardName: json['cardName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

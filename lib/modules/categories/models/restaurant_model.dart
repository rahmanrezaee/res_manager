class RestaurantModel {
  int activeOrder;
  Map restaurant = {
  
  };
  RestaurantModel({
  required  this.activeOrder,
  required  this.restaurant,
  });

  factory RestaurantModel.fromJson(json) {
    return new RestaurantModel(
      activeOrder: json["activeOrder"],
      restaurant: json["restaurant"],
    );
  }
}

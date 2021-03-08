class AddonModel {
  String name;
  int quantity;
  double price;

  AddonModel.toJson(element) {
    this.name = element['name'];
    this.quantity = element['quantity'];
    this.price = double.parse("${element['price']}");
  }
}

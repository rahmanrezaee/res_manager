class AddonModel {
  String name;
  int quantity = 1;
  double price;

  AddonModel();
  AddonModel.toJson(element) {
    this.name = element['name'];
    this.quantity = element['quantity'] ?? 1;
    this.price = double.parse("${element['price']}");
  }
}

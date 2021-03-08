import 'package:admin/modules/dishes/Models/AddonModel.dart';

class DishModel {
  String foodId;
  String foodName;
  int quantity;
  List<AddonModel> addOn = [];

  DishModel.toJson(element) {
    try {
      this.foodId = element['foodId'];
      this.foodName = element['foodName'];
      this.quantity = element['quantity'];
      List addonLi = element['addOn'];

     
      if (addonLi != null && addonLi.isNotEmpty) {
        addonLi.forEach((element) {
          addOn.add(AddonModel.toJson(element));
        });
      }
    } catch (e) {
      print("Error In dish $e");
    }
  }
}

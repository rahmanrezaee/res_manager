import 'dart:async';

import 'package:admin/modules/dishes/Models/AddonModel.dart';

import 'ImageModel.dart';

class DishModel {
  String foodId;
  String foodName;
  int quantity;
  int averageRating;
  String restaurantId;
  String categoryId;
  double price;
  List<AddonModel> addOn = [];
  String description;
  List<ImageModel> images = [];

  bool visibility;
  String preparationTime;

  DishModel();

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
  DishModel.toCatJson(element) {
    try {
      this.foodId = element['_id'];
      this.foodName = element['name'];
      this.visibility = element['visibility'];
      this.price = double.parse("${element['price']}");

      List photosRest = element['photos'];

      if (photosRest != null && photosRest.isNotEmpty) {
        photosRest.forEach((element) {
          images.add(ImageModel.toJson(element));
        });
      }
    } catch (e) {
      print("Error In dish $e");
    }
  }

  sendMap() {
    return {
      "restaurantId": this.restaurantId,
      "categoryId": this.categoryId,
      "name": this.foodName,
      "price": this.price,
      "addOn": this
          .addOn
          .map((data) => {"name": data.name, "price": data.price})
          .toList(),
      "description": this.description,
      "photos": this
          .images
          .map((data) => {"_id": data.id, "uriPath": data.url})
          .toList(),
      "preparationTime": this.preparationTime
    };
  }

  DishModel.toComplateJson(extractedData) {
    try {
      this.foodId = extractedData['food']['_id'];
      this.foodName = extractedData['food']['name'];
      this.visibility = extractedData['food']['visibility'];
      this.averageRating = extractedData['food']['averageRating'];
      this.restaurantId = extractedData['food']['restaurantId'];
      this.categoryId = extractedData['food']['categoryId'];
      this.description = extractedData['food']['description'];
      this.preparationTime = extractedData['food']['preparationTime'];
      this.price = double.parse("${extractedData['food']['price']}");

      List photosRest = extractedData['food']['photos'];

      if (photosRest != null && photosRest.isNotEmpty) {
        photosRest.forEach((element) {
          images.add(ImageModel.toJson(element));
        });
      }
      List addOnList = extractedData['food']['addOn'];

      if (addOnList != null && addOnList.isNotEmpty) {
        addOnList.forEach((element) {
          addOn.add(AddonModel.toJson(element));
        });
      }

    } catch (e) {
      print("Error In dish $e");
    }
  }
}

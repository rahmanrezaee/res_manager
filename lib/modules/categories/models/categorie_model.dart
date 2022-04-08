class CategoryModel {
  String id;
  String categoryName;
  int foodNumber;
  CategoryModel({
    required this.id,
   required this.categoryName,
   required this.foodNumber,
  });

  factory CategoryModel.fromJson(json) {
    return new CategoryModel(
      id: json['_id'],
      categoryName: json['categoryName'],
      foodNumber: json['foodNumber'],
    );
  }
}

class ContentManagementModel {
  String? title;
  String? body;
  String? slug;

  ContentManagementModel({this.title, this.body, this.slug});

  ContentManagementModel.fromJson(Map json) {
    try {
      this.title = json['title'];
      this.body = json['body'];
      this.slug = json['slug'];
    } catch (e) {
      print("error content Management: $e");
    }
  }
}

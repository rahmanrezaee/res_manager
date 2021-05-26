class ContentManagementModel {
  String title;
  String body;
  String slug;

  ContentManagementModel({this.title, this.body, this.slug});

  // ignore: missing_return
  factory ContentManagementModel.fromJson(Map json) {
    try {
      return ContentManagementModel(
        title: json['title'],
        body: json['body'],
        slug: json['slug'],
      );
    } catch (e) {
      print("error content Management: $e");
    }
  }
}

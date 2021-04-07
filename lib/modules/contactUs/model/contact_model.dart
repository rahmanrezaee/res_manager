class ContactModel {
  String username;
  String email;
  String restaurant;
  String subject;
  String message;
  ContactModel({
    username,
    email,
    restaurant,
    subject,
    message,
  });
  ContactModel.fromJson(json) {
    try {
      this.username =
          json['userId'] == null ? null : json['userId']['username'];
      this.email = json['userId'] == null ? null : json['userId']['email'];
      this.restaurant = json["restaurantId"] == null
          ? null
          : json["restaurantId"]['username'];
      this.subject = json['subject'];
      this.message = json['message'];
    } catch (e) {
      print("e $e");
    }
  }
}

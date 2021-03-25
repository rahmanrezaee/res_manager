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
    this.username = json['userId']['username'];
    this.email = json['userId']['email'];
    this.restaurant = json["restaurantId"]['username'];
    this.subject = json['subject'];
    this.message = json['message'];
  }
}

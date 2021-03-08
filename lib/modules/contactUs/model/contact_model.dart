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
  factory ContactModel.fromJson(json) {
    print("this is username: ${json['userId']['username']}");
    return ContactModel(
      username: json['userId']['username'],
      email: json['userId']['email'],
      restaurant: json['restaurantId']['username'],
      subject: json['subject'],
      message: json['message'],
    );
  }
}

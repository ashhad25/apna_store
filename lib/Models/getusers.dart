class User {
  int? user_id;
  String? user_name;
  String? user_email;
  String? user_password;
  String? user_image;

  User(
      {this.user_id,
      this.user_image,
      required this.user_name,
      required this.user_email,
      this.user_password});

  User.fromMap(Map<dynamic, dynamic> res) {
    user_id = res['user_id'];
    user_name = res['user_name'];
    user_email = res['user_email'];
    user_password = res['user_password'];
    user_image = res['user_image'];
  }

  Map<String, Object?> toMap() {
    return {
      'user_id': user_id,
      'user_name': user_name,
      'user_email': user_email,
      'user_password': user_password,
      'user_image': user_image
    };
  }
}

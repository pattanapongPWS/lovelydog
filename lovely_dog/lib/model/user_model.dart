class UserModel {
  int? userId;
  String? userEmail;
  String? userPassword;
  String? userFirstname;
  String? userLastname;
  String? userNickname;
  String? userPhone;
  String? userImg;
  String? userToken;

  UserModel(
      {this.userId,
      this.userEmail,
      this.userPassword,
      this.userFirstname,
      this.userLastname,
      this.userNickname,
      this.userPhone,
      this.userImg,
      this.userToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['user_email'];
    userPassword = json['user_password'];
    userFirstname = json['user_firstname'];
    userLastname = json['user_lastname'];
    userNickname = json['user_nickname'];
    userPhone = json['user_phone'];
    userImg = json['user_img'];
    userToken = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_email'] = this.userEmail;
    data['user_password'] = this.userPassword;
    data['user_firstname'] = this.userFirstname;
    data['user_lastname'] = this.userLastname;
    data['user_nickname'] = this.userNickname;
    data['user_phone'] = this.userPhone;
    data['user_img'] = this.userImg;
    data['token'] = this.userToken;
    return data;
  }
}

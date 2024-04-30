class UserPostModel {
  int? postId;
  String? postText;
  String? postImg;
  int? postLike;
  String? postDate;
  int? userId;
  String? userNickname;
  String? userImg;

  UserPostModel(
      {this.postId,
      this.postText,
      this.postImg,
      this.postLike,
      this.postDate,
      this.userId,
      this.userNickname,
      this.userImg});

  UserPostModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    postText = json['post_text'];
    postImg = json['post_img'];
    postLike = json['post_like'];
    postDate = json['post_date'];
    userId = json['user_id'];
    userNickname = json['user_nickname'];
    userImg = json['user_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['post_text'] = this.postText;
    data['post_img'] = this.postImg;
    data['post_like'] = this.postLike;
    data['post_date'] = this.postDate;
    data['user_id'] = this.userId;
    data['user_nickname'] = this.userNickname;
    data['user_img'] = this.userImg;
    return data;
  }
}

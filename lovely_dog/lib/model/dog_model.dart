class DogModel {
  int? dogId;
  int? userId;
  String? dogName;
  String? dogGender;
  String? dogGene;
  String? dogBirth;
  String? dogStatus;
  String? dogImg;
  int? dogWeight;

  DogModel(
      {this.dogId,
      this.userId,
      this.dogName,
      this.dogGender,
      this.dogGene,
      this.dogBirth,
      this.dogStatus,
      this.dogImg,
      this.dogWeight});

  DogModel.fromJson(Map<String, dynamic> json) {
    dogId = json['dog_id'];
    userId = json['user_id'];
    dogName = json['dog_name'];
    dogGender = json['dog_gender'];
    dogGene = json['dog_gene'];
    dogBirth = json['dog_birth'];
    dogStatus = json['dog_status'];
    dogImg = json['dog_img'];
    dogWeight = json['dog_weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dog_id'] = this.dogId;
    data['user_id'] = this.userId;
    data['dog_name'] = this.dogName;
    data['dog_gender'] = this.dogGender;
    data['dog_gene'] = this.dogGene;
    data['dog_birth'] = this.dogBirth;
    data['dog_status'] = this.dogStatus;
    data['dog_img'] = this.dogImg;
    data['dog_weight'] = this.dogWeight;
    return data;
  }
}

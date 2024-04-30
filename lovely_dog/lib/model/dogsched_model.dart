class DogSchedule {
  int? actId;
  int? dogId;
  String? actName;
  String? actType;
  String? actDetail;
  String? actDate;
  String? actTime;
  String? actImg;

  DogSchedule(
      {this.actId,
      this.dogId,
      this.actName,
      this.actType,
      this.actDetail,
      this.actDate,
      this.actTime,
      this.actImg});

  DogSchedule.fromJson(Map<String, dynamic> json) {
    actId = json['act_id'];
    dogId = json['dog_id'];
    actName = json['act_name'];
    actType = json['act_type'];
    actDetail = json['act_detail'];
    actDate = json['act_date'];
    actTime = json['act_time'];
    actImg = json['act_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['act_id'] = this.actId;
    data['dog_id'] = this.dogId;
    data['act_name'] = this.actName;
    data['act_type'] = this.actType;
    data['act_detail'] = this.actDetail;
    data['act_date'] = this.actDate;
    data['act_time'] = this.actTime;
    data['act_img'] = this.actImg;
    return data;
  }
}

// class DogSchedule {
//   int? actId;
//   String? actName;
//   String? actType;
//   String? actDetail;
//   String? actDate;
//   String? actImg;
//   int? dogId;
//   String? dogName;

//   DogSchedule(
//       {this.actId,
//       this.actName,
//       this.actType,
//       this.actDetail,
//       this.actDate,
//       this.actImg,
//       this.dogId,
//       this.dogName});

//   DogSchedule.fromJson(Map<String, dynamic> json) {
//     actId = json['act_id'];
//     actName = json['act_name'];
//     actType = json['act_type'];
//     actDetail = json['act_detail'];
//     actDate = json['act_date'];
//     actImg = json['act_img'];
//     dogId = json['dog_id'];
//     dogName = json['dog_name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['act_id'] = this.actId;
//     data['act_name'] = this.actName;
//     data['act_type'] = this.actType;
//     data['act_detail'] = this.actDetail;
//     data['act_date'] = this.actDate;
//     data['act_img'] = this.actImg;
//     data['dog_id'] = this.dogId;
//     data['dog_name'] = this.dogName;
//     return data;
//   }
// }

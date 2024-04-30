class VaccineSchedModel {
  int? vacschedId;
  int? dogId;
  String? vacschedName;
  String? vacschedDetail;
  String? vacschedDate;
  String? vacschedTime;

  VaccineSchedModel(
      {this.vacschedId,
      this.dogId,
      this.vacschedName,
      this.vacschedDetail,
      this.vacschedDate,
      this.vacschedTime});

  VaccineSchedModel.fromJson(Map<String, dynamic> json) {
    vacschedId = json['vacsched_id'];
    dogId = json['dog_id'];
    vacschedName = json['vacsched_name'];
    vacschedDetail = json['vacsched_detail'];
    vacschedDate = json['vacsched_date'];
    vacschedTime = json['vacsched_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vacsched_id'] = this.vacschedId;
    data['dog_id'] = this.dogId;
    data['vacsched_name'] = this.vacschedName;
    data['vacsched_detail'] = this.vacschedDetail;
    data['vacsched_date'] = this.vacschedDate;
    data['vacsched_time'] = this.vacschedTime;
    return data;
  }
}

class VaccineModel {
  int? vacId;
  String? vacName;
  int? vacAge;
  String? vacDetail;

  VaccineModel({this.vacId, this.vacName, this.vacAge, this.vacDetail});

  VaccineModel.fromJson(Map<String, dynamic> json) {
    vacId = json['vac_id'];
    vacName = json['vac_name'];
    vacAge = json['vac_age'];
    vacDetail = json['vac_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vac_id'] = this.vacId;
    data['vac_name'] = this.vacName;
    data['vac_age'] = this.vacAge;
    data['vac_detail'] = this.vacDetail;
    return data;
  }
}

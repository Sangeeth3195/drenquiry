
import 'dart:convert';

ServiceList serviceListFromJson(String str) => ServiceList.fromJson(json.decode(str));

String serviceListToJson(ServiceList data) => json.encode(data.toJson());

class ServiceList {
  List<Result>? result;
  String? message;
  int? status;

  ServiceList({this.result, this.message, this.status});

  ServiceList.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Result {
  int? transVisitId;
  int? recNo;
  String? recDate;
  String? doctorName;
  String? hospitalName;
  String? address1;
  String? address2;
  String? latitude;
  String? longitude;
  String? doctorMobileNo;
  String? hospitalMobileNo;
  String? hospitalLandline;
  String? remarks;
  String? description;
  int? employeeId;
  int? companyId;
  int? branchId;
  bool? noEdit;
  String? createdDate;
  String? modifiedDate;
  int? createdBy;
  String? modifiedBy;
  bool? cancelled;

  Result(
      {this.transVisitId,
        this.recNo,
        this.recDate,
        this.doctorName,
        this.hospitalName,
        this.address1,
        this.address2,
        this.latitude,
        this.longitude,
        this.doctorMobileNo,
        this.hospitalMobileNo,
        this.hospitalLandline,
        this.remarks,
        this.description,
        this.employeeId,
        this.companyId,
        this.branchId,
        this.noEdit,
        this.createdDate,
        this.modifiedDate,
        this.createdBy,
        this.modifiedBy,
        this.cancelled});

  Result.fromJson(Map<String, dynamic> json) {
    transVisitId = json['transVisitId'];
    recNo = json['recNo'];
    recDate = json['recDate'];
    doctorName = json['doctorName'];
    hospitalName = json['hospitalName'];
    address1 = json['address1'];
    address2 = json['address2'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    doctorMobileNo = json['doctorMobileNo'];
    hospitalMobileNo = json['hospitalMobileNo'];
    hospitalLandline = json['hospitalLandline'];
    remarks = json['remarks'];
    description = json['description'];
    employeeId = json['employeeId'];
    companyId = json['companyId'];
    branchId = json['branchId'];
    noEdit = json['noEdit'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    cancelled = json['cancelled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transVisitId'] = this.transVisitId;
    data['recNo'] = this.recNo;
    data['recDate'] = this.recDate;
    data['doctorName'] = this.doctorName;
    data['hospitalName'] = this.hospitalName;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['doctorMobileNo'] = this.doctorMobileNo;
    data['hospitalMobileNo'] = this.hospitalMobileNo;
    data['hospitalLandline'] = this.hospitalLandline;
    data['remarks'] = this.remarks;
    data['description'] = this.description;
    data['employeeId'] = this.employeeId;
    data['companyId'] = this.companyId;
    data['branchId'] = this.branchId;
    data['noEdit'] = this.noEdit;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    data['createdBy'] = this.createdBy;
    data['modifiedBy'] = this.modifiedBy;
    data['cancelled'] = this.cancelled;
    return data;
  }
}


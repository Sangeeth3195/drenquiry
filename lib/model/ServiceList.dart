// To parse this JSON data, do
//
//     final serviceList = serviceListFromJson(jsonString);

import 'dart:convert';

ServiceList serviceListFromJson(String str) => ServiceList.fromJson(json.decode(str));

String serviceListToJson(ServiceList data) => json.encode(data.toJson());

class ServiceList {
  List<Result>? result;
  int? count;
  String? message;
  int? status;

  ServiceList({
    this.result,
    this.count,
    this.message,
    this.status,
  });

  factory ServiceList.fromJson(Map<String, dynamic> json) => ServiceList(
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    count: json["count"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "count": count,
    "message": message,
    "status": status,
  };
}

class Result {
  DateTime? bookingDate;
  String? bookingTime;
  String? lat;
  String? lng;
  String? items;
  int? id;
  int? paymentMode;
  String? address;
  double? total;
  double? discount;
  String? tax;
  double? subTotal;
  String? status;
  String? statusType;
  String? slug;
  String? paymentName;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? customerId;
  String? phoneNumber;
  String? phoneWithCode;
  String? customerName;
  int? statusId;

  Result({
    this.bookingDate,
    this.bookingTime,
    this.lat,
    this.lng,
    this.items,
    this.id,
    this.paymentMode,
    this.address,
    this.total,
    this.discount,
    this.tax,
    this.subTotal,
    this.status,
    this.statusType,
    this.slug,
    this.paymentName,
    this.createdAt,
    this.updatedAt,
    this.customerId,
    this.phoneNumber,
    this.phoneWithCode,
    this.customerName,
    this.statusId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    bookingDate: DateTime.parse(json["booking_Date"]),
    bookingTime: json["booking_Time"],
    lat: json["lat"],
    lng: json["lng"],
    items: json["items"],
    id: json["id"],
    paymentMode: json["payment_Mode"],
    address: json["address"],
    total: json["total"].toDouble(),
    discount: json["discount"].toDouble(),
    tax: json["tax"],
    subTotal: json["sub_Total"].toDouble(),
    status: json["status"],
    statusType: json["status_type"],
    slug: json["slug"],
    paymentName: json["payment_name"],
    createdAt: DateTime.parse(json["created_At"]),
    updatedAt: DateTime.parse(json["updated_At"]),
    customerId: json["customer_Id"],
    phoneNumber: json["phone_number"],
    phoneWithCode: json["phone_With_Code"],
    customerName: json["customer_Name"],
    statusId: json["status_id"],
  );

  Map<String, dynamic> toJson() => {
    "booking_Date": bookingDate!.toIso8601String(),
    "booking_Time": bookingTime,
    "lat": lat,
    "lng": lng,
    "items": items,
    "id": id,
    "payment_Mode": paymentMode,
    "address": address,
    "total": total,
    "discount": discount,
    "tax": tax,
    "sub_Total": subTotal,
    "status": status,
    "status_type": statusType,
    "slug": slug,
    "payment_name": paymentName,
    "created_At": createdAt!.toIso8601String(),
    "updated_At": updatedAt!.toIso8601String(),
    "customer_Id": customerId,
    "phone_number": phoneNumber,
    "phone_With_Code": phoneWithCode,
    "customer_Name": customerName,
    "status_id": statusId,
  };
}

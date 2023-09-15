// To parse this JSON data, do
//
//     final amountInformation = amountInformationFromJson(jsonString);

import 'dart:convert';

AmountInformation amountInformationFromJson(String str) =>
    AmountInformation.fromJson(json.decode(str));

String amountInformationToJson(AmountInformation data) =>
    json.encode(data.toJson());

class AmountInformation {
  AmountInformation({
    this.id,
    this.title,
    this.description,
    this.selectedDate,
    this.selectedTime,
    this.typeOfAmount,
    this.amount,
  });

  int? id;
  String? title;
  String? description;
  String? selectedDate;
  String? selectedTime;
  String? typeOfAmount;
  int? amount;

  factory AmountInformation.fromJson(Map<String, dynamic> json) =>
      AmountInformation(
        id: json['id'],
        title: json["title"],
        description: json["description"],
        selectedDate: json["selected date"],
        selectedTime: json["selected time"],
        typeOfAmount: json["type of amount"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "selected date": selectedDate,
        "selected time": selectedTime,
        "type of amount": typeOfAmount,
        "amount": amount,
      };
}

// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:mongo_dart/mongo_dart.dart';

class AddressModel {
  final ObjectId? id;
  final String userId;
  final String fullName;
  final String mobileNumber;
  final String pincode;
  final String addressLine1;
  final String addressLine2;
  final String landmark;
  final String city;
  final String state;
  final String country;
  final bool isDefault;
  final String addressType; // home, work, other
  final DateTime createdAt;
  final DateTime updatedAt;

  AddressModel({
    this.id,
    required this.userId,
    required this.fullName,
    required this.mobileNumber,
    required this.pincode,
    required this.addressLine1,
    this.addressLine2 = '',
    this.landmark = '',
    required this.city,
    required this.state,
    this.country = 'India',
    this.isDefault = false,
    this.addressType = 'home',
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'pincode': pincode,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'landmark': landmark,
      'city': city,
      'state': state,
      'country': country,
      'isDefault': isDefault,
      'addressType': addressType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'] as ObjectId?,
      userId: json['userId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      mobileNumber: json['mobileNumber']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      addressLine1: json['addressLine1']?.toString() ?? '',
      addressLine2: json['addressLine2']?.toString() ?? '',
      landmark: json['landmark']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? 'India',
      isDefault: json['isDefault'] as bool? ?? false,
      addressType: json['addressType']?.toString() ?? 'home',
      createdAt: json['createdAt'] as DateTime? ?? DateTime.now(),
      updatedAt: json['updatedAt'] as DateTime? ?? DateTime.now(),
    );
  }
}

// lib/features/customer/address/models/address_model.dart
class AddressModel {
  final String? id;
  final String fullName;
  final String mobileNumber;
  final String pincode;
  final String addressLine1;
  final String? addressLine2;
  final String? landmark;
  final String city;
  final String state;
  final String country;
  final String addressType;
  final bool isDefault;
  final DateTime? createdAt;

  AddressModel({
    this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.pincode,
    required this.addressLine1,
    this.addressLine2,
    this.landmark,
    required this.city,
    required this.state,
    required this.country,
    required this.addressType,
    required this.isDefault,
    this.createdAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String,
      mobileNumber: json['mobileNumber'] as String,
      pincode: json['pincode'] as String,
      addressLine1: json['addressLine1'] as String,
      addressLine2: json['addressLine2'] as String?,
      landmark: json['landmark'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      addressType: json['addressType'] as String,
      isDefault: json['isDefault'] as bool,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'addressId': id,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'pincode': pincode,
      'addressLine1': addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) 'addressLine2': addressLine2,
      if (landmark != null && landmark!.isNotEmpty) 'landmark': landmark,
      'city': city,
      'state': state,
      'country': country,
      'addressType': addressType,
      'isDefault': isDefault,
    };
  }

  AddressModel copyWith({
    String? id,
    String? fullName,
    String? mobileNumber,
    String? pincode,
    String? addressLine1,
    String? addressLine2,
    String? landmark,
    String? city,
    String? state,
    String? country,
    String? addressType,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      pincode: pincode ?? this.pincode,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      addressType: addressType ?? this.addressType,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
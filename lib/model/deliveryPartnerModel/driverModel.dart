import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DeliveryPartnerModel {
  String? name;
  String? profilePicUrl;
  String? mobileNumber;
  String? driverID;
  String? vehicleRegistrationNumber;
  String? drivingLicenseNumber;
  DateTime? registeredDateTime;
  String? activeDeliveryRequestID;
  String? driverStatus;
  String? cloudMessagingToken;
  DeliveryPartnerModel({
    this.name,
    this.profilePicUrl,
    this.mobileNumber,
    this.driverID,
    this.vehicleRegistrationNumber,
    this.drivingLicenseNumber,
    this.registeredDateTime,
    this.activeDeliveryRequestID,
    this.driverStatus,
    this.cloudMessagingToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePicUrl': profilePicUrl,
      'mobileNumber': mobileNumber,
      'driverID': driverID,
      'vehicleRegistrationNumber': vehicleRegistrationNumber,
      'drivingLicenseNumber': drivingLicenseNumber,
      'registeredDateTime': registeredDateTime?.millisecondsSinceEpoch,
      'activeDeliveryRequestID': activeDeliveryRequestID,
      'driverStatus': driverStatus,
      'cloudMessagingToken': cloudMessagingToken,
    };
  }

  factory DeliveryPartnerModel.fromMap(Map<String, dynamic> map) {
    return DeliveryPartnerModel(
      name: map['name'] != null ? map['name'] as String : null,
      profilePicUrl:
          map['profilePicUrl'] != null ? map['profilePicUrl'] as String : null,
      mobileNumber:
          map['mobileNumber'] != null ? map['mobileNumber'] as String : null,
      driverID: map['driverID'] != null ? map['driverID'] as String : null,
      vehicleRegistrationNumber: map['vehicleRegistrationNumber'] != null
          ? map['vehicleRegistrationNumber'] as String
          : null,
      drivingLicenseNumber: map['drivingLicenseNumber'] != null
          ? map['drivingLicenseNumber'] as String
          : null,
      registeredDateTime: map['registeredDateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['registeredDateTime'] as int)
          : null,
      activeDeliveryRequestID: map['activeDeliveryRequestID'] != null
          ? map['activeDeliveryRequestID'] as String
          : null,
      driverStatus:
          map['driverStatus'] != null ? map['driverStatus'] as String : null,
      cloudMessagingToken: map['cloudMessagingToken'] != null
          ? map['cloudMessagingToken'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryPartnerModel.fromJson(String source) =>
      DeliveryPartnerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

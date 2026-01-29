import 'dart:io';

class VehicleDealRequest {
  final int vehicleId;
  final DateTime startDate;
  final DateTime endDate;
  final MainDriverData mainDriver;
  final bool secondDriverEnabled;
  final SecondDriverData? secondDriver;
  final String paymentMethod;
  final String? passcode;
  final String? bankilyPhoneNumber;
  final bool kilometerIllimitedPerDay;
  final bool allRiskCarInsurance;
  final bool addChildsChair;
  final int pickupAreaId;
  final int returnAreaId;
  final bool secondDriverAmount;
  VehicleDealRequest({
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.mainDriver,
    this.secondDriverEnabled = false,
    this.secondDriver,
    required this.paymentMethod,
    this.passcode,
    this.bankilyPhoneNumber,
    this.kilometerIllimitedPerDay = false,
    this.allRiskCarInsurance = false,
    this.addChildsChair = false,
    required this.pickupAreaId,
    required this.returnAreaId,
    this.secondDriverAmount = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'mainDriver': mainDriver.toJson(),
      'secondDriverEnabled': secondDriverEnabled,
      'secondDriver': secondDriver?.toJson(),
      'paymentMethod': paymentMethod,
      'passcode': passcode,
      'bankilyPhoneNumber': bankilyPhoneNumber,
      'kilometerIllimitedPerDay': kilometerIllimitedPerDay,
      'allRiskCarInsurance': allRiskCarInsurance,
      'addChildsChair': addChildsChair,
      'pickupAreaId': pickupAreaId,
      'returnAreaId': returnAreaId,
    };
  }
}

class MainDriverData {
  final String documentType;
  final File? idCardImage;
  final String firstName;
  final String lastName;
  final String familyName;
  final String phoneNumber;
  final String idNumber;
  final DateTime birthDate;
  final DateTime idExpiryDate;
  final File? drivingLicenseImage;
  final String drivingLicenseNumber;
  final DateTime drivingLicenseIssueDate;
  final String vehicleReceptionPlace;
  final String vehicleReceptionLat;
  final String vehicleReceptionLng;
  final String vehicleReturnPlace;
  final String vehicleReturnLat;
  final String vehicleReturnLng;

  MainDriverData({
    required this.documentType,
    this.idCardImage,
    required this.firstName,
    required this.lastName,
    required this.familyName,
    required this.phoneNumber,
    required this.idNumber,
    required this.birthDate,
    required this.idExpiryDate,
    this.drivingLicenseImage,
    required this.drivingLicenseNumber,
    required this.drivingLicenseIssueDate,
    required this.vehicleReceptionPlace,
    required this.vehicleReceptionLat,
    required this.vehicleReceptionLng,
    required this.vehicleReturnPlace,
    required this.vehicleReturnLat,
    required this.vehicleReturnLng,
  });

  Map<String, dynamic> toJson() {
    return {
      'documentType': documentType,
      'firstName': firstName,
      'lastName': lastName,
      'familyName': familyName,
      'phoneNumber': phoneNumber,
      'idNumber': idNumber,
      'birthDate': birthDate.toIso8601String(),
      'idExpiryDate': idExpiryDate.toIso8601String(),
      'drivingLicenseNumber': drivingLicenseNumber,
      'drivingLicenseIssueDate': drivingLicenseIssueDate.toIso8601String(),
      'vehicleReceptionPlace': vehicleReceptionPlace,
      'vehicleReceptionLat': vehicleReceptionLat,
      'vehicleReceptionLng': vehicleReceptionLng,
      'vehicleReturnPlace': vehicleReturnPlace,
      'vehicleReturnLat': vehicleReturnLat,
      'vehicleReturnLng': vehicleReturnLng,
    };
  }
}

class SecondDriverData {
  final String documentType;
  final File? idCardImage;
  final String firstName;
  final String lastName;
  final String familyName;
  final String phoneNumber;
  final String idNumber;
  final DateTime birthDate;
  final DateTime idExpiryDate;
  final File? drivingLicenseImage;
  final String drivingLicenseNumber;
  final DateTime drivingLicenseIssueDate;

  SecondDriverData({
    required this.documentType,
    this.idCardImage,
    required this.firstName,
    required this.lastName,
    required this.familyName,
    required this.phoneNumber,
    required this.idNumber,
    required this.birthDate,
    required this.idExpiryDate,
    this.drivingLicenseImage,
    required this.drivingLicenseNumber,
    required this.drivingLicenseIssueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'documentType': documentType,
      'firstName': firstName,
      'lastName': lastName,
      'familyName': familyName,
      'phoneNumber': phoneNumber,
      'idNumber': idNumber,
      'birthDate': birthDate.toIso8601String(),
      'idExpiryDate': idExpiryDate.toIso8601String(),
      'drivingLicenseNumber': drivingLicenseNumber,
      'drivingLicenseIssueDate': drivingLicenseIssueDate.toIso8601String(),
    };
  }
}

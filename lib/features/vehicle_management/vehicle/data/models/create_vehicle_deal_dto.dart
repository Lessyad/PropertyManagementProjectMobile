class CreateVehicleDealDto {
  final String vehicleId;
  final bool isUser;
  final String name;
  final String phoneNumber;
  final String nni; // ID Number
  final String birthDate;
  final String idCardExpiryDate;
  final String paymentMethod;
  final String? passCode; // Pour Bankily
  final String idCardImage;
  final String driveLicenseImage;
  final int numberOfRentalDays;
  final String drivingLicenseNumber;
  final String drivingLicenseExpiry;
  final String? vehicleReceptionPlace;
  final String? vehicleReturnPlace;
  final double? vehicleReceptionLat;
  final double? vehicleReceptionLng;
  final double? vehicleReturnLat;
  final double? vehicleReturnLng;

  final double totalAmount;

  CreateVehicleDealDto({
    required this.vehicleId,
    required this.isUser,
    required this.name,
    required this.phoneNumber,
    required this.nni,
    required this.birthDate,
    required this.idCardExpiryDate,
    required this.paymentMethod,
    this.passCode,
    required this.idCardImage,
    required this.driveLicenseImage,
    required this.numberOfRentalDays,
    required this.drivingLicenseNumber,
    required this.drivingLicenseExpiry,
    this.vehicleReceptionPlace,
    this.vehicleReturnPlace,
    this.vehicleReceptionLat,
    this.vehicleReceptionLng,
    this.vehicleReturnLat,
    this.vehicleReturnLng,
    required this.totalAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'VehicleId': vehicleId,
      'IsUser': isUser,
      'Name': name,
      'PhoneNumber': phoneNumber,
      'NNI': nni,
      'BirthDate': birthDate,
      'IdCardExpiryDate': idCardExpiryDate,
      'PaymentMethod': paymentMethod,
      'PassCode': passCode,
      'IdCardImage': idCardImage,
      'NumberOfRentalDays': numberOfRentalDays,
      'DrivingLicenseNumber': drivingLicenseNumber,
      'DrivingLicenseExpiry': drivingLicenseExpiry,
      'VehicleReceptionPlace': vehicleReceptionPlace,
      'VehicleReturnPlace': vehicleReturnPlace,
      'VehicleReceptionLat': vehicleReceptionLat,
      'VehicleReceptionLng': vehicleReceptionLng,
      'VehicleReturnLng':vehicleReturnLng,
      'VehicleReturnLat' :vehicleReturnLat,
      'TotalAmount': totalAmount,
    };
  }

  Map<String, String> toFormData() {
    final Map<String, String> formData = {
      'VehicleId': vehicleId,
      'IsUser': isUser.toString(),
      'Name': name,
      'PhoneNumber': phoneNumber,
      'NNI': nni,
      'BirthDate': birthDate,
      'IdCardExpiryDate': idCardExpiryDate,
      'PaymentMethod': paymentMethod,
      'NumberOfRentalDays': numberOfRentalDays.toString(),
      'DrivingLicenseNumber': drivingLicenseNumber,
      'DrivingLicenseExpiry': drivingLicenseExpiry,
      'TotalAmount': totalAmount.toString(),
    };

    // Ajouter les coordonnées GPS si disponibles
    if (vehicleReceptionLat != null && vehicleReceptionLng != null) {
      formData['VehicleReceptionLat'] = vehicleReceptionLat.toString();
      formData['VehicleReceptionLng'] = vehicleReceptionLng.toString();
    }

    if (vehicleReturnLat != null && vehicleReturnLng != null) {
      formData['VehicleReturnLat'] = vehicleReturnLat.toString();
      formData['VehicleReturnLng'] = vehicleReturnLng.toString();
    }

    // Ajouter les textes des lieux (optionnel)
    if (vehicleReceptionPlace != null && vehicleReceptionPlace!.isNotEmpty) {
      formData['VehicleReceptionPlace'] = vehicleReceptionPlace!;
    }
    if (vehicleReturnPlace != null && vehicleReturnPlace!.isNotEmpty) {
      formData['VehicleReturnPlace'] = vehicleReturnPlace!;
    }

    if (passCode != null && passCode!.isNotEmpty) {
      formData['PassCode'] = passCode!;
    }

    return formData;
  }
}

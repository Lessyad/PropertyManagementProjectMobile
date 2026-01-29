part of 'rent_vehicle_cubit.dart';

class RentVehicleState extends Equatable {
  final String userName;
  final String phoneNumber;
  final String userID;
  final String age;
  final String vehicleReceptionLat;
  final String vehicleReceptionPlace;
  final String vehicleReturnLat;
  final String vehicleReceptionLng;
  final String vehicleReturnLng;
  final String vehicleReturnPlace;
  final DateTime? birthDate;
  final DateTime? idExpirationDate;
  final DateTime? rentalDate;
  final DateTime? returnDate;
  final File? idImage;
  final File? driveLicenseImage;
  final String drivingLicenseNumber;
  final DateTime? drivingLicenseExpiry;
  final RequestState selectIDImageState;
  final RequestState selectDriveLicenseImageState;
  final RequestState paymentState;
  final bool validateIDImage;
  final bool validateDriveLicenseImage;

  const RentVehicleState({
    this.userName = '',
    this.phoneNumber = '',
    this.userID = '',
    this.age = '',
    this.vehicleReceptionLat = '',
    this.vehicleReceptionPlace = '',
    this.vehicleReturnLat = '',
    this.vehicleReturnPlace = '',
    this.vehicleReceptionLng = '',
    this.vehicleReturnLng = '',
    this.birthDate,
    this.idExpirationDate,
    this.rentalDate,
    this.returnDate,
    this.idImage,
    this.driveLicenseImage,
    this.drivingLicenseNumber = '',
    this.drivingLicenseExpiry,
    this.selectIDImageState = RequestState.initial,
    this.selectDriveLicenseImageState = RequestState.initial,
    this.paymentState = RequestState.initial,
    this.validateIDImage = false,
    this.validateDriveLicenseImage = false,
  });

  RentVehicleState copyWith({
    String? userName,
    String? phoneNumber,
    String? userID,
    String? age,
    String? vehicleReceptionLat,
    String? vehicleReceptionPlace,
    String? vehicleReturnLat,
    String? vehicleReceptionLng,
    String? vehicleReturnLng,
    String? vehicleReturnPlace,
    DateTime? birthDate,
    DateTime? idExpirationDate,
    DateTime? rentalDate,
    DateTime? returnDate,
    File? idImage,
    File? driveLicenseImage,
    String? drivingLicenseNumber,
    DateTime? drivingLicenseExpiry,
    RequestState? selectIDImageState,
    RequestState? selectDriveLicenseImageState,
    RequestState? paymentState,
    bool? validateIDImage,
    bool? validateDriveLicenseImage,
  }) {
    return RentVehicleState(
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userID: userID ?? this.userID,
      age: age ?? this.age,
      vehicleReceptionLat: vehicleReceptionLat ?? this.vehicleReceptionLat,
      vehicleReceptionPlace: vehicleReceptionPlace ?? this.vehicleReceptionPlace,
      vehicleReturnLat: vehicleReturnLat ?? this.vehicleReturnLat,
      vehicleReturnPlace: vehicleReturnPlace ?? this.vehicleReturnPlace,
      birthDate: birthDate ?? this.birthDate,
      idExpirationDate: idExpirationDate ?? this.idExpirationDate,
      rentalDate: rentalDate ?? this.rentalDate,
      returnDate: returnDate ?? this.returnDate,
      idImage: idImage ?? this.idImage,
      driveLicenseImage: driveLicenseImage ?? this.driveLicenseImage,
      drivingLicenseNumber: drivingLicenseNumber ?? this.drivingLicenseNumber,
      drivingLicenseExpiry: drivingLicenseExpiry ?? this.drivingLicenseExpiry,
      selectIDImageState: selectIDImageState ?? this.selectIDImageState,
      selectDriveLicenseImageState: selectDriveLicenseImageState ?? this.selectDriveLicenseImageState,
      paymentState: paymentState ?? this.paymentState,
      validateIDImage: validateIDImage ?? this.validateIDImage,
      validateDriveLicenseImage: validateDriveLicenseImage ?? this.validateDriveLicenseImage,
      vehicleReceptionLng: vehicleReceptionLng ?? this.vehicleReceptionLng, // ← AJOUTEZ
      vehicleReturnLng: vehicleReturnLng ?? this.vehicleReturnLng,
    );
  }

  @override
  List<Object?> get props => [
    userName,
    phoneNumber,
    userID,
    age,
    vehicleReceptionLat,
    vehicleReceptionPlace,
    vehicleReturnLat,
    vehicleReturnPlace,
    birthDate,
    idExpirationDate,
    rentalDate,
    returnDate,
    idImage,
    driveLicenseImage,
    drivingLicenseNumber,
    drivingLicenseExpiry,
    selectIDImageState,
    selectDriveLicenseImageState,
    paymentState,
    validateIDImage,
    validateDriveLicenseImage,
  ];
}

class ApiConstants {
  ApiConstants._();

  // static const String baseUrl = "https://rough-mira-seen-app-f74aa423.koyeb.app/api/";
  static const String baseUrl = "https://inmaapi-gkgxdtc0c6ded3bk.spaincentral-01.azurewebsites.net/api/";
  //    static const String baseUrl ="http://192.168.100.13:5000/api/" ;
  static const String properties= "${baseUrl}properties/";
  static const String banners= "${baseUrl}banners/";
  static const String notifications= "${baseUrl}notifications/";

  static const String apartment= "${baseUrl}apartments/";
  static const String villa= "${baseUrl}villas/";
  static const String building= "${baseUrl}buildings/";
  static const String land= "${baseUrl}lands/";
  static const String login= "${baseUrl}auth/login/";
  static const String signUp= "${baseUrl}auth/register/";

  static const String sendOTP= "${baseUrl}auth/send-otp/";
  static const String verifyOTP= "${baseUrl}auth/verify-otp/";
  static const String resetPassword= "${baseUrl}auth/reset-password/";


  /// location

  static const String countries= "${baseUrl}countries/";
  static const String states= "${baseUrl}states/";
  static const String cities= "${baseUrl}cities/";


  static const String wishList= "${baseUrl}users/wish-list/";
  static const String user= "${baseUrl}users/me/";
  static const String propertyBusyDays= "${baseUrl}property-partner-busy-dates";
  static const String propertyOrderDetails= "${baseUrl}property-order-detail";
  static const String amenities= "${baseUrl}amenities";
  static const String preview= "${baseUrl}viewing-requests";
  static const String appointments= "${baseUrl}viewing-requests-list";
  static const String appointmentUpdate= "${baseUrl}viewing-requests";


  static const String deals= "${baseUrl}deals/";
  static const String transactions= "${baseUrl}payments/transactions/";
  static const String payments= "${baseUrl}payments/";
  static const String banks= "${baseUrl}payments/banks/";
  static const String balance= "${baseUrl}payments/balance/";
  static const String contracts= "${baseUrl}contracts";
  static const String contact= "${baseUrl}contact-us/";
  static const String notification= "${baseUrl}notifications/devices/";
  static const String updateFcmToken= "${baseUrl}auth/update-fcm-token/";

  static const String vehicles = "${baseUrl}Vehicles" ;
  static const String vehicleDetails = "${baseUrl}Vehicles/";
  static const String vehicleWishList = '${baseUrl}VehicleWishlist/';
  static const String vehicleMakes = "${baseUrl}VehicleMakes/";
  static const  String VehicleDeals = "${baseUrl}Vehicles/deal/" ;
  
  // Nouveaux endpoints pour l'upload direct d'images
  static const String generateUploadUrls = "${baseUrl}ImageUpload/generate-upload-urls";
  static const String verifyUploads = "${baseUrl}ImageUpload/verify-uploads";
}

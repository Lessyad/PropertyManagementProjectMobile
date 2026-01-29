//flutter pub run easy_localization:generate -S "assets/translations" -O "lib/core/translation"
abstract class LocaleKeys {
  // Error Messages
  // .
  static const somethingWentWrong = 'somethingWentWrong';
  static const badGateway = 'badGateway';
  static const internalServerError = 'internalServerError';
  static const notFound = 'notFound';
  static const forbidden = 'forbidden';
  static const unauthorized = 'unauthorized';
  static const badRequest = 'badRequest';
  static const sendTimeout = 'sendTimeout';
  static const receiveTimeout = 'receiveTimeout';
  static const connectionTimeout = 'connectionTimeout';
  static const requestCancelled = 'requestCancelled';
  static const noInternet = 'noInternet';
  static const String rentalDetails = 'rental_details';
  static const String rentalSummary = 'rental_summary';
  static const realEstate = 'realEstate';
  static const vehiclesSearchscreen = 'vehiclesSearchscreen';
  static const cars = 'cars';
  static const halls = 'halls';
  static const hotels = 'hotels';
  static const addYourRealState = 'addYourRealState';
  static const update ='update';

  static const authenticateToAccessTheApp = 'authenticateToAccessTheApp';

  static const home = 'home';
  static const myBookings = 'myBookings';
  static const favorites = 'favorites';
  static const myProfile = 'myProfile';



  static const chooseYourIdealPropertyEasily = 'chooseYourIdealPropertyEasily';
  static const String baseRental = 'base_rental';
  // static const String previous = 'previous';
  static const String confirmBooking = 'confirm_booking';
  static const forSale = 'forSale';
  static const forRent = 'forRent';
  static const String selectedVehicle = 'selected_vehicle';
  static const String apartment = "apartment";
  static const String villa = "villa";
  static const String building = "building";
  static const String land = "land";

  /// apartment sub type
  static const String studio = "studio";
  static const String duplex = "duplex";
  static const String penthouse = "penthouse";

  static const String residential = "residential";
  static const String commercial = "commercial";
  static const String mixedUse = "mixedUse";

  static const String freehold = "freehold";
  static const String agricultural = "agricultural";
  static const String industrial = "industrial";

  static const String standalone = 'standalone';
  static const String twinHouse = 'twinHouse';
  static const String townHouse = 'townHouse';

  static const String completed = "completed";
  static const String active = "active";
  static const String cancelled = "cancelled";

  static const String reserved = "reserved";
  static const String available = "available";

  static const String coming = "coming";

  static const String iAmBuyer = "iAmBuyer";
  static const String anotherBuyer = "anotherBuyer";

  static const String areaUnit = "areaUnit";
  static const String contract = "contract";
  static const String arabic = "arabic";
  static const String english = "english";
  static const String french = "french";

  static const contactUs = 'contactUs';
  static const errorOpeningLink = 'errorOpeningLink';

  static const onBoardingTitle1 = 'onBoardingTitle1';
  static const onBoardingDesc1 = 'onBoardingDesc1';
  static const onBoardingDesc2 = 'onBoardingDesc2';
  static const onBoardingTitle2 = 'onBoardingTitle2';
  static const onBoardingDesc3 = 'onBoardingDesc3';
  static const onBoardingDesc4 = 'onBoardingDesc4';
  static const onBoardingTitle3 = 'onBoardingTitle3';
  static const onBoardingDesc5 = 'onBoardingDesc5';
  static const onBoardingDesc6 = 'onBoardingDesc6';
  static const login = 'login';
  static const next = 'next';
  static const skip = 'skip';

  static const String floorLabel = 'floor_label';
  static const String floorsLabel = 'floors_label';
  static const String apartmentPerFloorLabel = 'apartment_per_floor_label';
  static const String startingFrom = 'starting_from';
  static const String furnished = 'furnished';
  static const String notFurnished = 'not_furnished';
  static const String licensed = 'licensed';
  static const String notLicensed = 'not_licensed';

  static const String servicesSeeAll = 'servicesSeeAll';

  // New keys for HomeScreen
  static const String homeAppBarMessage = 'homeAppBarMessage';
  static const String homeSearchHint = 'homeSearchHint';
  static const String homeServiceNotAvailable = 'homeServiceNotAvailable';
  static const String homeApartments = 'homeApartments';
  static const String homeLands = 'homeLands';
  static const String homeBuildings = 'homeBuildings';
  static const String homeVillas = 'homeVillas';
  static const String homeNoAvailable = 'homeNoAvailable';
  static const String homeNearby = 'homeNearby';
  static const String homeErrorOccurred = 'homeErrorOccurred';

  static const String notificationsScreenTitle = 'notificationsScreenTitle';
  static const String notificationsScreenNoNotifications =
      'notificationsScreenNoNotifications';
  static const String notificationsScreenExploreOffers =
      'notificationsScreenExploreOffers';

  static const String emptyScreenNoBookings = 'emptyScreenNoBookings';
  static const String emptyScreenBrowseOffers = 'emptyScreenBrowseOffers';
  static const String emptyScreenExploreOffers = 'emptyScreenExploreOffers';

  static const String emptyScreenNoFavorites = 'emptyScreenNoFavorites';
  static const String emptyScreenAddFavorites = 'emptyScreenAddFavorites';

  static const String errorScreenTitle = 'errorScreenTitle';
  static const String errorScreenMessage = 'errorScreenMessage';
  static const String errorScreenBackToHome = 'errorScreenBackToHome';

  static const String chargeWalletScreenTitle = 'chargeWalletScreenTitle';
  static const String chargeScreenCurrentBalance = 'chargeScreenCurrentBalance';
  static const String chargeScreenCurrency = 'chargeScreenCurrency';
  static const String chargeScreenWithdraw = 'chargeScreenWithdraw';
  static const String transactionHistoryTitle = 'transactionHistoryTitle';
  static const String transactionHistoryNoTransactions =
      'transactionHistoryNoTransactions';
  static const String transactionHistoryEmptyMessage =
      'transactionHistoryEmptyMessage';
  static const String transactions = 'transactions';

  static const String appControlsLanguage = 'appControlsLanguage';
  static const String appControlsTerms = 'appControlsTerms';
  static const String appControlsDarkMode = 'appControlsDarkMode';
  static const String appControlsNotifications = 'appControlsNotifications';
  static const String appControlsLinkError = 'appControlsLinkError';

  static const String languageSheetTitle = 'languageSheetTitle';
  static const String languageSheetCancel = 'languageSheetCancel';
  static const String languageSheetConfirm = 'languageSheetConfirm';

  static const String logOutAndContactUsLogOut = 'logOutAndContactUsLogOut';
  static const String logOutAndContactUsContactUs =
      'logOutAndContactUsContactUs';

  static const String managePropertiesTitle = 'managePropertiesTitle';
  static const String managePropertiesDescription =
      'managePropertiesDescription';

  static const String nameAndPhoneGuestName = 'nameAndPhoneGuestName';
  static const String nameAndPhoneCreateAccount = 'nameAndPhoneCreateAccount';

  static const String removeAccountTitle = 'removeAccountTitle';
  static const String removeAccountConfirmation = 'removeAccountConfirmation';
  static const String removeAccountWarning = 'removeAccountWarning';
  static const String removeAccountCancel = 'removeAccountCancel';
  static const String pickupDate = 'pickup_date';
  static const String returnDate = 'return_date';
  static const String removeAccountSuccessMessage =
      'removeAccountSuccessMessage';

  static const String userScreensAppointments = 'userScreensAppointments';
  static const String userScreensElectronicContracts =
      'userScreensElectronicContracts';

  static const String changePassword = 'changePassword';

  static const String changePasswordTitle = 'changePasswordTitle';
  static const String currentPasswordLabel = 'currentPasswordLabel';
  static const String currentPasswordHint = 'currentPasswordHint';
  static const String newPasswordLabel = 'newPasswordLabel';
  static const String newPasswordHint = 'newPasswordHint';
  static const String confirmNewPasswordLabel = 'confirmNewPasswordLabel';
  static const String confirmNewPasswordHint = 'confirmNewPasswordHint';
  static const String passwordsDoNotMatch = 'passwordsDoNotMatch';
  static const String changePasswordWarning = 'changePasswordWarning';
  static const String cancelButton = 'cancelButton';
  static const String saveButton = 'saveButton';
  static const String changePasswordSuccess = 'changePasswordSuccess';

  // New keys for FormValidator
  static const String thisFieldIsRequired = 'thisFieldIsRequired';
  static const String enterField = 'enterField';
  static const String enterValidNumber = 'enterValidNumber';
  static const String enterValidNumberInField = 'enterValidNumberInField';
  static const String numberMustBeGreaterThanZero =
      'numberMustBeGreaterThanZero';
  static const String fieldMustBeGreaterThanZero = 'fieldMustBeGreaterThanZero';
  static const String numberMustBeGreaterThan = 'numberMustBeGreaterThan';
  static const String fieldMustBeGreaterThan = 'fieldMustBeGreaterThan';
  static const String numberMustBeLessThan = 'numberMustBeLessThan';
  static const String fieldMustBeLessThan = 'fieldMustBeLessThan';
  static const String password = 'password';
  static const String passwordMustBeAtLeast8Chars =
      'passwordMustBeAtLeast8Chars';
  static const String fieldMustBeAtLeast8Chars = 'fieldMustBeAtLeast8Chars';
  static const String passwordMustContainNumber = 'passwordMustContainNumber';
  static const String fieldMustContainNumber = 'fieldMustContainNumber';
  static const String costSummary = 'cost_summary';

  static const String passwordMustContainLetter = 'passwordMustContainLetter';
  static const String fieldMustContainLetter = 'fieldMustContainLetter';
  static const String rentalDuration = 'rental_duration';
  static const String withdrawTitle = 'withdrawTitle';
  static const String withdrawNameLabel = 'withdrawNameLabel';
  static const String withdrawAmountLabel = 'withdrawAmountLabel';
  static const String withdrawNameHint = 'withdrawNameHint';
  static const String withdrawAmountHint = 'withdrawAmountHint';
  static const String withdrawIbanLabel = 'withdrawIbanLabel';
  static const String withdrawIbanHint = 'withdrawIbanHint';
  static const String withdrawBankLabel = 'withdrawBankLabel';
  static const String withdrawBankHint = 'withdrawBankHint';
  static const String withdrawButton = 'withdrawButton';
  static const String withdrawSuccess = 'withdrawSuccess';
  static const String availableBalance = 'availableBalance';
  static const String selectBank = 'selectBank';
  static const String bankLoadingError = 'bankLoadingError';
  static const String termsAndConditions = 'termsAndConditions';
  static const String selectBankRequired = 'selectBankRequired';
  static const String amountRequired = 'amountRequired';
  static const String invalidAmount = 'invalidAmount';
  static const String amountMustBePositive = 'amountMustBePositive';
  static const String insufficientAmount = 'insufficientAmount';
  static const String ibanRequired = 'ibanRequired';
  static const String invalidIbanFormat = 'invalidIbanFormat';
  static const String loginRequired = 'loginRequired';
  static const String selectCountryHint = 'selectCountryHint';
  static const String country = 'country';
  static const String countryRequired = 'countryRequired';

  static const String searchResults = 'search_results';
  static const String vehiclesFound = 'vehicles_found';
  static const String vehiclesFoundCount = 'vehicles_found_count';
  static const String modifyFilters = 'modify_filters';
  static const String searchError = 'search_error';
  static const String tryAgain = 'try_again';
  static const String noResultsFound = 'no_results_found';
  static const String noVehiclesMatch = 'no_vehicles_match';

  static const String descriptionLabel = 'descriptionLabel';

  static const String propertyDetailsLabel = 'propertyDetailsLabel';
  static const String property = 'propertyDetailsLabel';
  static const String unfurnished = 'unfurnished';
  static const String months = 'months';
  static const String floors = 'floors';
  static const String floor = 'floor';
  static const String readyForBuilding = 'readyForBuilding';
  static const String notReadyForBuilding = 'notReadyForBuilding';

  static const String locationAndNearbyAreas = 'locationAndNearbyAreas';
  static const String amenitiesLabel = 'amenitiesLabel';

  static const String cannotOpenDialer = 'cannotOpenDialer';
  static const String preview = 'preview';
  static const String bookNow = 'bookNow';
  static const String bookNowError = 'bookNowError';
  static const String previewError = 'previewError';
  static const String previewConfirmed = 'previewConfirmed';

  static const String readMore = 'readMore';
  static const String readLess = 'readLess';

  static const String profilePage = 'profilePage';
  static const String fullName = 'fullName';
  static const String enterFullName = 'enterFullName';
  static const String fullNameRequired = 'fullNameRequired';
  static const String phoneNumber = 'phoneNumber';
  static const String enterPhoneNumber = 'enterPhoneNumber';
  static const String phoneNumberRequired = 'phoneNumberRequired';
  static const String idNumber = 'idNumber';
  static const String enterIdNumber = 'enterIdNumber';
  static const String idNumberRequired = 'idNumberRequired';
  static const String dateOfBirth = 'dateOfBirth';
  static const String idExpirationDate = 'idExpirationDate';
  static const String updatingData = 'updatingData';
  static const String dataFetchError = 'dataFetchError';
  static const String cancel = 'cancel';
  static const String saveChanges = 'saveChanges';
  static const String authenticationFailed = 'authenticationFailed';
  static const String retryAuthentication = 'retryAuthentication';
  static const String authenticationSuccessful = 'authenticationSuccessful';

  static const String resetPassword = 'resetPassword';
  static const String createPassword = 'createPassword';
  static const String createNewPasswordHint = 'createNewPasswordHint';
  static const String createStrongPasswordHint = 'createStrongPasswordHint';
  static const String newPassword = 'newPassword';
  static const String signUp = 'signUp';
  static const String confirm = 'confirm';
  static const String accountCreatedSuccessfully = 'accountCreatedSuccessfully';
  static const String passwordChangedSuccessfully =
      'passwordChangedSuccessfully';

  static const String phoneRequired = 'phoneRequired';
  static const String passwordRequired = 'passwordRequired';

  static const String enterSecurityCode = 'enterSecurityCode';
  static const String codeSentTo = 'codeSentTo';
  static const String didNotReceiveCode = 'didNotReceiveCode';
  static const String resend = 'resend';

  static const String recoverPassword = 'recoverPassword';
  static const String recoverPasswordHint = 'recoverPasswordHint';
  static const String mobileNumber = 'mobileNumber';
  static const String nameRequired = 'nameRequired';

  static const String createAccount = 'createAccount';

  static const String confirmPassword = 'confirmPassword';
  static const String confirmPasswordRequired = 'confirmPasswordRequired';
  static const String minEightChars = 'minEightChars';
  static const String minOneNumber = 'minOneNumber';
  static const String minOneLetter = 'minOneLetter';

  static const String enterAsGuest = 'enterAsGuest';

  static const String noAccount = 'noAccount';
  static const String createOneNow = 'createOneNow';
  static const String forgotPassword = 'forgotPassword';

  static const String alreadyHaveAccount = 'alreadyHaveAccount';

  static const String enterYourName = 'enterYourName';

  static const String hello = 'hello';
  static const String welcome = 'welcome';
  static const String createAccountForFeatures = 'createAccountForFeatures';
  static const String location = 'location';
  static const String selectLocation = 'selectLocation';

  static const String filter = 'filter';
  static const String choosePerfectProperty = 'choosePerfectProperty';
  static const String searchForProperty = 'searchForProperty';
  static const String addYourProperty = 'addYourProperty';
  static const String didntFindSuitableProperty = 'didntFindSuitableProperty';
  static const String contactUsForBestOptions = 'contactUsForBestOptions';

  static const String changeAppointmentDate = 'changeAppointmentDate';
  static const String propertyPreview = 'propertyPreview';
  static const String setAppointmentDate = 'setAppointmentDate';
  static const String completePayment = 'completePayment';
  static const String selectPreviewDateTime = 'selectPreviewDateTime';
  static const String date = 'date';
  static const String chooseDate = 'chooseDate';
  static const String advisorWarningMessage = 'advisorWarningMessage';
  static const String transparencyWarningMessage = 'transparencyWarningMessage';
  static const String transmission ='transmission';

  static const String paymentDetails = 'paymentDetails';
  static const String amountToBePaid = 'amountToBePaid';
  static const String currency = 'currency';
  static const String creditCard = 'creditCard';
  static const String paypal = 'paypal';
  static const String wallet = 'wallet';
  static const String bankily = 'bankily';
  static const String passCode = 'passCode';
  static const String paymentWarning = 'paymentWarning';
  static const String securityWarning = 'securityWarning';
  static const String paymentConfirmationInProgress =
      'paymentConfirmationInProgress';
  static const String loadingDataInProgress = 'loadingDataInProgress';

  static const String previous = 'previous';
  static const String confirmAppointment = 'confirmAppointment';
  static const String appointmentConfirmedMessage =
      'appointmentConfirmedMessage';

  static const String time = 'time';
  static const String chooseTime = 'chooseTime';
  static const String noAvailableTimes = 'noAvailableTimes';

  static const String payment = 'payment';
  static const String refund = 'refund';
  static const String withdrawal = 'withdrawal';
  static const String walletRecharge = 'walletRecharge';

  static const String propertyDeal = 'propertyDeal';
  static const String viewingRequest = 'viewingRequest';
  static const String money = 'money';
  static const String inKey = 'inKey';
  static const String toKey = 'toKey';

  static const String youMustLogin = 'youMustLogin';
  static const String loginFirstHint = 'loginFirstHint';

  static const String completePaymentWithWallet = 'completePaymentWithWallet';
  static const String insufficientWalletBalance = 'insufficientWalletBalance';
  static const String willBeDeducted = 'willBeDeducted';
  static const String currencyEGP = 'currencyEGP';
  static const String fromYourWallet = 'fromYourWallet';
  static const String chooseAnotherPaymentMethod = 'chooseAnotherPaymentMethod';
  static const String payWithCreditCard = 'payWithCreditCard';
  static const String payWithPayPal = 'payWithPayPal';
  static const String paypalDescription = 'paypalDescription';

  static const String submit = 'submit';
  static const String propertyBookedSuccessfully = 'propertyBookedSuccessfully';

  static const String bookProperty = 'bookProperty';
  static const String saleDetails = 'saleDetails';
  static const String buyerData = 'buyerData';

  static const String idPhoto = 'idPhoto';
  static const String uploadClearIdPhotos = 'uploadClearIdPhotos';
  static const String birthDate = 'birthDate';
  static const String phoneNumberPlaceholder = 'phoneNumberPlaceholder';
  static const String buyerNamePlaceholder = 'buyerNamePlaceholder';
  static const String idNumberPlaceholder = 'idNumberPlaceholder';

  static const String logOutWarning = 'logOutWarning';
  static const String logOutConfirmation = 'logOutConfirmation';

  static const completingPayment = 'completingPayment';
  static const reviewData = 'reviewData';
  static const paymentMethods = 'paymentMethods';
  static const egp = 'egp';
  static const expirationDate = 'expirationDate';
  static const notSpecified = 'notSpecified';
  static const paymentVerificationWarning = 'paymentVerificationWarning';
  static const securePaymentMessage = 'securePaymentMessage';

  static const saleDetailsHeader = 'saleDetailsHeader';
  static const saleConditions = 'saleConditions';

  // Labels
  static const bookingDepositLabel = 'bookingDepositLabel';
  static const finalPriceLabel = 'finalPriceLabel';

  // Warning Messages
  static const bookingProcedureWarning = 'bookingProcedureWarning';
  static const bookingConfirmationWarning = 'bookingConfirmationWarning';
  static const booked = 'booked';
  static const vehicles = 'vehicles';

  //  just pour tester les images

  static const testDriveConfirmed = 'testDriveConfirmed';
  static const testDriveError = 'testDriveError';

  static const rentalConfirmed = 'rentalConfirmed';
  static const rentalError = 'rentalError';

  static const testDrive = 'testDrive';
  static const rentNow = 'rentNow';

  static const searchForVehicle = 'searchForVehicle';

  static const vehiclefavorites = 'vehiclefavorites';
  static const emptyScreenNoVehicleFavorites = 'emptyscreennovehiclefavorites';
  static const emptyScreenAddVehicleFavorites =
      'emptyscreenaddfehiclefavorites';
  static const emptyScreenExploreVehicles = 'emptyscreenexplorevehicles';
  static const String fullProtection = 'full_protection';
  static const String childSafetySeat = 'child_safety_seat';

  //des const pour les libele de l'ecran vehicl_screen_details

  static const String tenantInformation = 'tenant_information';
  // static const String idPhoto = 'id_photo';
  static const String drivingLicense = 'driving_license';
  static const String uploadClearIdPhoto = 'upload_clear_id_photo';
  static const String uploadClearDrivingLicense =
      'upload_clear_driving_license';
  static const String tenantFullNamePlaceholder =
      'tenant_full_name_placeholder';
  static const String age = 'age';
  static const String agePlaceholder = 'age_placeholder';
  static const String ageRequired = 'age_required';
  static const String minimumAgeRequired = 'minimum_age_required';
  static const String vehicleReceptionPlace = 'vehicle_reception_place';
  static const String vehicleReturnPlace = 'vehicle_return_place';
  static const String rentalDates = 'rental_dates';
  static const String startDate = 'start_date';
  static const String endDate = 'end_date';
  static const String selectReceptionPlace = 'select_reception_place';
  static const String selectReturnPlace = 'select_return_place';
  static const String receptionPlace = 'reception_place';
  static const String returnPlace = 'return_place';
  static const String selectOnMap = 'select_on_map';


  // static const String currency = 'currency';
  static const String currencyPerDay = 'currency_per_day';
  static const String vehicleDescription = 'vehicle_description';
  static const String technicalSpecifications = 'technical_specifications';
  static const String brand = 'brand';
  static const String model = 'model';
  static const String color = 'color';
  static const String mileage = 'mileage';
  static const String km = 'km';
  static const String seatsNumber = 'seats_number';
  static const String year = 'year';
  static const String licensePlate = 'license_plate';
  static const String rentalOptions = 'rental_options';
  static const String extraKilometers = 'extra_kilometers';
  static const String extraKilometersDesc = 'extra_kilometers_desc';
  static const String fullInsurance = 'full_insurance';
  static const String fullInsuranceDesc = 'full_insurance_desc';
  static const String childSeat = 'child_seat';
  static const String childSeatDesc = 'child_seat_desc';
  static const String estimatedPricePerDay = 'estimated_price_per_day';
  static const String missingInfoTitle = 'missing_info_title';
  static const String missingInfoMessage = 'missing_info_message';
  //des const pour les libele de  l'ecran LocationPickerScreen


  static const String searchAddressHint = 'search_address_hint';
  static const String addressNotFound = 'address_not_found';
  static const String cannotGetLocation = 'cannot_get_location';
  static const String casablancaMorocco = 'casablanca_morocco';
  static const String confirmButton = 'confirm_button';
  //des const pour les libele de l'ecran de RentVehicleMainScreen

  static const String vehicleRental = 'vehicle_rental';
  static const String informationStep = 'information_step';
  static const String paymentStep = 'payment_step';
  static const String previousButton = 'previous_button';
  static const String nextButton = 'next_button';
  static const String invalidVehicleId = 'invalid_vehicle_id';
  static const String vehicleDataLoadError = 'vehicle_data_load_error';
  static const String retryButton = 'retry_button';
  static const String vehicle = 'vehicle';
  // static const String nameRequired = 'name_required';
  // static const String idNumberRequired = 'id_number_required';
  static const String birthDateRequired = 'birth_date_required';
  static const String idExpirationDateRequired = 'id_expiration_date_required';
  static const String rentalStartDateRequired = 'rental_start_date_required';
  static const String rentalEndDateRequired = 'rental_end_date_required';
  static const String idPhotoRequired = 'id_photo_required';
  static const String drivingLicenseRequired = 'driving_license_required';
  static const String rentalSuccessMessage = 'rental_success_message';

  //des const pour les libele de l'ecran de RentVehiclePayment

  static const String paymentFinalization = 'payment_finalization';
  static const String vehicleInformation = 'vehicle_information';
  static const String days = 'days';
  static const String hours = 'hours';
  // static const String currencyPerDay = 'currency_per_day';
  // static const String paymentDetails = 'payment_details';
  static const String dailyPrice = 'daily_price';
  // static const String currency = 'currency';
  static const String numberOfDays = 'number_of_days';
  static const String total = 'total';
  static const String paymentMethod = 'payment_method';
  // static const String creditCard = 'credit_card';
  static const String creditCardDescription = 'credit_card_description';
  // static const String wallet = 'wallet';
  static const String walletDescription = 'wallet_description';
  // static const String bankily = 'bankily';
  static const String bankityDescription = 'bankity_description';
  static const String confirmPaymentButton = 'confirm_payment_button';
  static const String paymentTerms = 'payment_terms';
  static const String fillAllRequiredFields = 'fill_all_required_fields';

//des const pour les libele de l'ecran details
//   static const String technicalSpecifications = 'technical_specifications';
//   static const String vehicleDescription = 'vehicle_description';
  static const String brandLabel = 'brand_label';
  static const String modelLabel = 'model_label';
  static const String colorLabel = 'color_label';
  static const String mileageLabel = 'mileage_label';
  static const String kilometers = 'kilometers';
  static const String fuelTypeLabel = 'fuel_type_label';
  static const String fuelTypeGasoline = 'fuel_type_gasoline';
  static const String fuelTypeDiesel = 'fuel_type_diesel';
  static const String fuelTypeElectric = 'fuel_type_electric';
  static const String fuelTypeHybrid = 'fuel_type_hybrid';
  static const String transmissionLabel = 'transmission_label';
  static const String transmissionManual = 'transmission_manual';
  static const String transmissionAutomatic = 'transmission_automatic';
  static const String airConditioningLabel = 'air_conditioning_label';
  static const String yes = 'yes';
  static const String no = 'no';
  static const String seatsLabel = 'seats_label';
  static const String yearLabel = 'year_label';
  static const String licensePlateLabel = 'license_plate_label';
  static const String vinLabel = 'vin_label';

  // des const pour les libele de l'ecran search vehicle :

  // static const String searchForVehicle = 'search_for_vehicle';
  static const String allFilters = 'all_filters';
  static const String searchResultsFound = 'search_results_found';
  static const String clearAll = 'clear_all';
  
  // Price filter keys
  static const String filterByPrice = 'filter_by_price';
  static const String maximumDailyPrice = 'maximum_daily_price';
  static const String enterMaxPrice = 'enter_max_price';
  static const String quickPriceOptions = 'quick_price_options';
  static const String clear = 'clear';
  static const String apply = 'apply';
  // static const String searchError = 'search_error';
  static const String noVehiclesAvailable = 'no_vehicles_available';
  static const String tryAdjustingFilters = 'try_adjusting_filters';
  static const String resetFiltersButton = 'reset_filters_button';
  static const String noResults = 'no_results';
  static const String noVehiclesMatchSearch = 'no_vehicles_match_search';
  static const String resetSearchButton = 'reset_search_button';

  //labels for search screen
  static const String vehicleSearchTitle = 'vehicle_search_title';
  static const String searchCriteriaHint = 'search_criteria_hint';
  static const String fuelTransmissionFilters = 'fuel_transmission_filters';
  static const String fuelType = 'fuel_type';
  static const String gasoline = 'gasoline';
  static const String diesel = 'diesel';
  static const String transmissionType = 'transmission_type';
  static const String automatic = 'automatic';
  static const String manual = 'manual';
  static const String locationSection = 'location_section';
  // static const String country = 'country';
  static const String city = 'city';
  static const String receptionInfoSection = 'reception_info_section';
  static const String receptionDate = 'reception_date';
  static const String receptionTime = 'reception_time';
  // static const String receptionPlace = 'reception_place';
  static const String deliveryInfoSection = 'delivery_info_section';
  static const String deliveryDate = 'delivery_date';
  static const String deliveryTime = 'delivery_time';
  static const String deliveryPlace = 'delivery_place';
  static const String vehicleDetailsSection = 'vehicle_details_section';
  static const String vehicleCategory = 'vehicle_category';
  static const String driverInfoSection = 'driver_info_section';
  static const String driverAge = 'driver_age';
  static const String ageValidationSuccess = 'age_validation_success';
  static const String ageValidationError = 'age_validation_error';
  static const String selectTime = 'select_time';
  static const String select = 'select';
  // static const String cancelButton = 'cancel_button';

  static const String availableVehicles = 'available_vehicles';
  static const String refresh = 'refresh';

  static const String loginRequiredForFavorites =
      'login_required_for_favorites';
  static const String statusAvailable = 'status_available';
  static const String statusRented = 'status_rented';
  static const String statusMaintenance = 'status_maintenance';
  static const String statusSold = 'status_sold';
  // static const String reserved = 'reserved';
  static const String pricePerDay = 'price_per_day';
  static const String pricePerWeek = 'price_per_week';

  static const String vehicleDetails = 'vehicle_details';
  // static const String dailyPrice = 'daily_price';
  static const String weeklyPrice = 'weekly_price';

  static const String paymentTitle = 'payment_title';
  static const String orderSummary = 'order_summary';
  // static const String paymentMethod = 'payment_method';
  // static const String creditCard = 'credit_card';
  static const String creditCardDesc = 'credit_card_desc';
  static const String mobilePayment = 'mobile_payment';
  static const String mobilePaymentDesc = 'mobile_payment_desc';
  static const String walletPayment = 'wallet_payment';
  static const String walletPaymentDesc = 'wallet_payment_desc';
  static const String cardInfo = 'card_info';
  static const String cardHolderName = 'card_holder_name';
  static const String cardHolderNameHint = 'card_holder_name_hint';
  static const String cardNumber = 'card_number';
  static const String cardNumberHint = 'card_number_hint';
  static const String expiryDate = 'expiry_date';
  static const String expiryDateHint = 'expiry_date_hint';
  static const String cvv = 'cvv';
  static const String cvvHint = 'cvv_hint';
  static const String pin = 'pin';
  static const String pinHint = 'pin_hint';
  static const String mobilePaymentInstructions = 'mobile_payment_instructions';
  static const String amountToDebit = 'amount_to_debit';
  static const String totalToPay = 'total_to_pay';
  static const String backButton = 'back_button';
  static const String payNow = 'pay_now';
  static const String paymentSuccess = 'payment_success';


  static const String tenantInfo = 'tenant_info';
  static const String mainTenant = 'main_tenant';
  static const String idDocumentType = 'id_document_type';
  static const String idCard = 'id_card';
  static const String passport = 'passport';
  static const String residencePermit = 'residence_permit';
  static const String idCardPhoto = 'id_card_photo';
  static const String passportPhoto = 'passport_photo';
  static const String residencePermitPhoto = 'residence_permit_photo';
  static const String uploadClearDocument = 'upload_clear_document';
  static const String personalInfo = 'personal_info';
  static const String firstName = 'first_name';
  static const String enterFirstName = 'enter_first_name';
  static const String lastName = 'last_name';
  static const String enterLastName = 'enter_last_name';
  static const String familyName = 'family_name';
  static const String enterFamilyName = 'enter_family_name';
  // static const String phoneNumber = 'phone_number';
  static const String phoneNumberHint = 'phone_number_hint';
  // static const String idNumber = 'id_number';
  static const String idNumberHint = 'id_number_hint';
  // static const String birthDate = 'birth_date';
  // static const String drivingLicense = 'driving_license';
  static const String uploadClearLicense = 'upload_clear_license';
  static const String licenseDetails = 'license_details';
  static const String licenseNumber = 'license_number';
  static const String licenseNumberHint = 'license_number_hint';
  static const String licenseIssueDate = 'license_issue_date';
  static const String secondDriver = 'second_driver';
  static const String extraFees = 'extra_fees';
  static const String documents = 'documents';
  static const String idDocumentPhoto = 'id_document_photo';
  static const String licensePhoto = 'license_photo';
  static const String secondDriverFirstNameHint = 'second_driver_first_name_hint';
  static const String secondDriverLastNameHint = 'second_driver_last_name_hint';
  static const String secondDriverFamilyNameHint = 'second_driver_family_name_hint';
  // static const String age = 'age';
  static const String ageHint = 'age_hint';
  // static const String ageRequired = 'age_required';
  static const String validAgeRequired = 'valid_age_required';
  static const String minAge18 = 'min_age_18';
  static const String maxAge80 = 'max_age_80';
  static const String chooseSource = 'choose_source';
  static const String camera = 'camera';
  static const String gallery = 'gallery';
  static const String imageAdded = 'image_added';
  static const String idDocumentUploaded = 'id_document_uploaded';
  static const String licenseUploaded = 'license_uploaded';
  static const String selectDate = 'select_date';
  // static const String chooseDate = 'choose_date';
  // static const String next = 'next';
  static const String error = 'error';
  static const String fillAllFields = 'fill_all_fields';
  static const String or = 'or';
  static const String rentalContract = 'rental_contract';
  static const String rentalContractTitle = 'rental_contract_title';
  static const String readTermsCarefully = 'read_terms_carefully';
  // static const String termsAndConditions = 'terms_and_conditions';
  static const String rentedVehicle = 'rented_vehicle';
  static const String brandModel = 'brand_model';
  static const String category = 'category';
  // static const String color = 'color';
  // static const String dailyPrice = 'daily_price';
  static const String rentalPeriod = 'rental_period';
  // static const String startDate = 'start_date';
  // static const String endDate = 'end_date';
  static const String at = 'at';
  static const String pickupLocation = 'pickup_location';
  static const String returnLocation = 'return_location';
  static const String additionalOptions = 'additional_options';
  // static const String extraKilometers = 'extra_kilometers';
  // static const String fullInsurance = 'full_insurance';
  static const String childSeatOption = 'child_seat_option';
  static const String included = 'included';
  static const String totalAmount = 'total_amount';
  static const String generalConditions = 'general_conditions';
  static const String condition1 = 'condition_1';
  static const String condition2 = 'condition_2';
  static const String condition3 = 'condition_3';
  static const String condition4 = 'condition_4';
  static const String condition5 = 'condition_5';
  static const String condition6 = 'condition_6';
  static const String condition7 = 'condition_7';
  static const String acceptanceClause = 'acceptance_clause';
  static const String acceptTerms = 'accept_terms';
  static const String proceedToPayment = 'proceed_to_payment';


  // contact infos
  static const contact_us = 'contact_us';
  static const name = 'name';
  static const contactToGetHelp = 'contactToGetHelp';
  static const enterMessage = 'enterMessage';
  static const writeInquiry = 'writeInquiry';
  static const messageSentSuccessively = 'messageSentSuccessively';
  static const message = "message";
  static const send = "send";
  static const cancellation = "cancellation";
  static const myAppointments = "myAppointments";
  static const myElectronicContracts = "myElectronicContracts";
  static const nomElectronicContracts = "nomElectronicContracts";
  static const myElectronicContractsAppearance =
      "myElectronicContractsAppearance";
  static const myRealEstate = "myRealEstate";

  // static const String technicalSpecifications = 'technical_specifications';
  // static const String vehicleDescription = 'vehicle_description';
  // static const String brand = 'brand';
  // static const String model = 'model';
  // static const String mileage = 'mileage';
  // static const String km = 'km';
  // static const String fuelType = 'fuel_type';
  // static const String transmission = 'transmission';
  static const String airConditioning = 'air_conditioning';
  static const String seatsCount = 'seats_count';
  // static const String year = 'year';
  // static const String licensePlate = 'license_plate';
  static const String vin = 'vin';
  // static const String gasoline = 'gasoline';
  // static const String diesel = 'diesel';
  static const String electric = 'electric';
  static const String hybrid = 'hybrid';
  // static const String manual = 'manual';
  // static const String automatic = 'automatic';

  // Add New Real Estate Screen Labels
  static const String propertyAddedSuccessfully = 'propertyAddedSuccessfully';
  static const String propertyUpdatedSuccessfully = 'propertyUpdatedSuccessfully';
  static const String processingProperty = 'processingProperty';
  static const String loadingPropertyData = 'loadingPropertyData';
  static const String editProperty = 'editProperty';
  static const String addProperty = 'addProperty';
  static const String basicInformation = 'basicInformation';
  static const String priceAndDescription = 'priceAndDescription';
  static const String locationAndFeatures = 'locationAndFeatures';
  static const String mainInformation = 'mainInformation';
  static const String operationType = 'operationType';
  // static const String category = 'category';
  static const String propertyType = 'propertyType';
  static const String type = 'type';
  static const String address = 'address';
  static const String enterBriefAddress = 'enterBriefAddress';
  static const String description = 'description';
  static const String enterDetailedDescription = 'enterDetailedDescription';
  static const String price = 'price';
  static const String enterPropertyPrice = 'enterPropertyPrice';
  static const String monthlyRent = 'monthlyRent';
  static const String specifyMonthlyRent = 'specifyMonthlyRent';
  static const String rentalDurationInMonths = 'rentalDurationInMonths';
  static const String specifyRentalDuration = 'specifyRentalDuration';
  static const String renewable = 'renewable';
  // static const String yes = 'yes';
  // static const String no = 'no';
  static const String firstImageWillBeMain = 'firstImageWillBeMain';
  static const String uploadClearPropertyImages = 'uploadClearPropertyImages';
  static const String nearbyServicesAndFacilities = 'nearbyServicesAndFacilities';
  static const String furniture ='furniture';

  // static const String floor = 'floor';
  static const String enterFloorNumber = 'enter_floor_number';
  static const String numberOfRooms = 'number_of_rooms';
  static const String specifyNumberOfRooms = 'specify_number_of_rooms';
  static const String numberOfBathrooms = 'number_of_bathrooms';
  static const String specifyNumberOfBathrooms = 'specify_number_of_bathrooms';
  // static const String floors = 'floors';

  static const String area = 'area';
  static const String enterAreaInSquareMeters = 'enter_area_in_square_meters';
  static const String licenseStatus = 'license_status';
  // static const String licensed = 'licensed';
  // static const String notLicensed = 'not_licensed';
  static const String readyForConstruction = 'ready_for_construction';
  static const String needsPermit = 'needs_permit';

  // Clés pour les controllers (si nécessaire)
  static const String landAreaController = 'land_area_controller';

  static const String numberOfFloors = 'number_of_floors';
  static const String specifyNumberOfFloors = 'specify_number_of_floors';
  static const String apartmentsPerFloor = 'apartments_per_floor';
  static const String specifyApartmentsPerFloor = 'specify_apartments_per_floor';

  static const String selectCountry = 'select_country';
  // static const String country = 'country';
  static const String paymentOptions = 'payment_options';
  static const String choosePaymentMethod = 'choose_payment_method';
  // static const String selectLocation = 'select_location';

  static const String selectStateAndCity = 'select_state_and_city';
  static const String state = 'state';
  // static const String city = 'city';

  static const String startRental = 'start_rental';

  static const String receptionCity = 'reception_city';
  static const String deliveryCity = 'delivery_city';

  // Vehicle Payment Authentication
  static const String vehicle_payment_requires_login = 'vehicle_payment_requires_login';
  static const String please_login_to_pay = 'please_login_to_pay';
  static const String redirect_to_login = 'redirect_to_login';
  
  // Currency Labels
  static const String default_currency_mru = 'default_currency_mru';
  static const String currency_per_day = 'currency_per_day';
  static const String total_amount = 'total_amount';
  static const String payment_amount = 'payment_amount';

  // Vehicle Deal Error Messages
  static const String errorCannotRentOwnVehicle = 'error_cannot_rent_own_vehicle';
  static const String errorVehicleNotAvailable = 'error_vehicle_not_available';
  static const String errorNoPartnerAssociated = 'error_no_partner_associated';
  static const String errorPartnerInfoIncomplete = 'error_partner_info_incomplete';
  static const String errorInvalidRentalDuration = 'error_invalid_rental_duration';
  static const String errorInsufficientDeposit = 'error_insufficient_deposit';
  static const String errorMainDriverRequired = 'error_main_driver_required';
  static const String errorSecondDriverRequired = 'error_second_driver_required';
  static const String errorUserNotAuthenticated = 'error_user_not_authenticated';
  static const String errorVehicleNotFound = 'error_vehicle_not_found';
  static const String errorPartnerNotFound = 'error_partner_not_found';
  static const String errorConfigMissing = 'error_config_missing';
  static const String errorImageRequired = 'error_image_required';
  static const String errorImageTooLarge = 'error_image_too_large';
  static const String errorInvalidImageFormat = 'error_invalid_image_format';
  static const String errorDailyPriceInvalid = 'error_daily_price_invalid';
  static const String errorSeatsInvalid = 'error_seats_invalid';
  static const String errorUnauthorizedAction = 'error_unauthorized_action';
  static const String errorPropertyNotFound = 'error_property_not_found';
  static const String errorCityNotFound = 'error_city_not_found';
  static const String errorInvalidPropertySubtype = 'error_invalid_property_subtype';
  static const String errorViewingDatePast = 'error_viewing_date_past';
  static const String errorUserNotFound = 'error_user_not_found';
  static const String errorInvalidCredentials = 'error_invalid_credentials';
  static const String errorPhoneNumberAlreadyExists = 'error_phone_number_already_exists';
  static const String errorInvalidOtp = 'error_invalid_otp';
  static const String errorTokenExpired = 'error_token_expired';
  
  // Property Deal Error Messages
  static const String errorCannotDealOwnProperty = 'error_cannot_deal_own_property';
  static const String errorPropertyNotAvailable = 'error_property_not_available';
  static const String errorRentalDatesRequired = 'error_rental_dates_required';
  static const String errorEndDateAfterStartDate = 'error_end_date_after_start_date';
  static const String errorStartDateNotPast = 'error_start_date_not_past';
  static const String errorMinimumRentalDuration = 'error_minimum_rental_duration';
  static const String errorPropertyNotAvailableForDates = 'error_property_not_available_for_dates';
  static const String errorDatesNotApplicableForSale = 'error_dates_not_applicable_for_sale';
  
  // Property Filter Labels
  static const String filterPropertyCategory = 'filter_property_category';
  static const String filterFurnishing = 'filter_furnishing';
  static const String filterLicenseStatus = 'filter_license_status';
  static const String filterRentalDurationMonths = 'filter_rental_duration_months';
  static const String filterMinimum = 'filter_minimum';
  static const String filterMaximum = 'filter_maximum';
  static const String filterPrice = 'filter_price';
  static const String filterArea = 'filter_area';
  static const String filterPropertyType = 'filter_property_type';
  static const String filterSale = 'filter_sale';
  static const String filterRent = 'filter_rent';
  static const String filterFurnished = 'filter_furnished';
  static const String filterNotFurnished = 'filter_not_furnished';
  static const String filterReadyForBuilding = 'filter_ready_for_building';
  static const String filterNeedsPermit = 'filter_needs_permit';
  static const String filterCurrencyEGP = 'filter_currency_egp';
  static const String filterSquareMeters = 'filter_square_meters';
  static const String filterClearAll = 'filter_clear_all';
  static const String filterShowResults = 'filter_show_results';
  static const String filterAvailableForRenewal = 'filter_available_for_renewal';
  static const String filterMonth = 'filter_month';
  static const String filterMonths = 'filter_months';
  
  // Vehicle Filter Labels
  static const String filterLocationSection = 'filter_location_section';
  static const String filterReceptionInfoSection = 'filter_reception_info_section';
  static const String filterDeliveryInfoSection = 'filter_delivery_info_section';
  static const String filterVehicleDetailsSection = 'filter_vehicle_details_section';
  static const String filterDriverInfoSection = 'filter_driver_info_section';
  static const String filterGasoline = 'filter_gasoline';
  static const String filterDiesel = 'filter_diesel';
  static const String filterAutomatic = 'filter_automatic';
  static const String filterManual = 'filter_manual';
  static const String filterFuelType = 'filter_fuel_type';
  static const String filterTransmission = 'filter_transmission';
  static const String filterAgeValidationMessage = 'filter_age_validation_message';
  static const String filterHybrid = 'filter_hybrid';
  
  // Notification Labels
  static const String notificationNew = 'notification_new';
  static const String notificationRead = 'notification_read';
  static const String notificationUnread = 'notification_unread';
  static const String notificationEmptyTitle = 'notification_empty_title';
  static const String notificationEmptyMessage = 'notification_empty_message';
  static const String notificationErrorLoading = 'notification_error_loading';
  static const String notificationMarkAsRead = 'notification_mark_as_read';
  static const String notificationMarkAsUnread = 'notification_mark_as_unread';
  static const String notificationDelete = 'notification_delete';
  static const String notificationToday = 'notification_today';
  static const String notificationYesterday = 'notification_yesterday';
  static const String notificationDaysAgo = 'notification_days_ago';
  static const String notificationHoursAgo = 'notification_hours_ago';
  static const String notificationMinutesAgo = 'notification_minutes_ago';
  static const String notificationJustNow = 'notification_just_now';
  
  // Property Service Messages
  static const String propertyNotificationRented = 'property_notification_rented';
  static const String propertyNotificationSold = 'property_notification_sold';
  static const String propertyErrorNotFound = 'property_error_not_found';
  static const String propertyErrorCannotUpdatePendingDeals = 'property_error_cannot_update_pending_deals';
  static const String propertyErrorCannotDeletePendingDeals = 'property_error_cannot_delete_pending_deals';
  static const String propertyErrorNotOwner = 'property_error_not_owner';
  static const String propertyErrorImageNotFound = 'property_error_image_not_found';
  static const String propertyErrorCannotDeleteMainImage = 'property_error_cannot_delete_main_image';
  static const String propertyErrorImageNotAssociated = 'property_error_image_not_associated';
  static const String propertyErrorInvalidSubtype = 'property_error_invalid_subtype';
  static const String propertyErrorCityNotFound = 'property_error_city_not_found';
  static const String propertyErrorInvalidAmenities = 'property_error_invalid_amenities';
  static const String propertyErrorInvalidOperation = 'property_error_invalid_operation';
  static const String propertyErrorMonthlyRentRequired = 'property_error_monthly_rent_required';
  static const String propertyErrorMonthlyRentNotAllowed = 'property_error_monthly_rent_not_allowed';
  static const String propertyErrorUserNotFound = 'property_error_user_not_found';
  
  // Vehicle Service Messages
  static const String vehicleNotificationRented = 'vehicle_notification_rented';
  static const String vehicleErrorNotFound = 'vehicle_error_not_found';
  static const String vehicleErrorNotAuthorized = 'vehicle_error_not_authorized';
  static const String vehicleErrorUserIdRequired = 'vehicle_error_user_id_required';
  static const String vehicleErrorUserNotFound = 'vehicle_error_user_not_found';
  static const String vehicleErrorFullNamePhoneRequired = 'vehicle_error_full_name_phone_required';
  static const String vehicleErrorNotAssociatedWithPartner = 'vehicle_error_not_associated_with_partner';
  static const String vehicleErrorCouldNotRetrieveAfterCreation = 'vehicle_error_could_not_retrieve_after_creation';
  static const String vehicleErrorUnauthorizedAction = 'vehicle_error_unauthorized_action';
  static const String vehicleErrorInvalidStatusTransition = 'vehicle_error_invalid_status_transition';
  static const String vehicleErrorDailyPriceMustBePositive = 'vehicle_error_daily_price_must_be_positive';
  static const String vehicleErrorSeatsMustBeBetween = 'vehicle_error_seats_must_be_between';
  static const String vehicleErrorAtLeastOneImageRequired = 'vehicle_error_at_least_one_image_required';
  static const String vehicleErrorImageExceedsLimit = 'vehicle_error_image_exceeds_limit';
  static const String vehicleErrorInvalidImageFormat = 'vehicle_error_invalid_image_format';
  
  // Success Messages
  static const String successVehicleDealCreated = 'success_vehicle_deal_created';
  static const String successPaymentCompleted = 'success_payment_completed';
  static const String successVehicleAdded = 'success_vehicle_added';
  static const String successVehicleUpdated = 'success_vehicle_updated';
  static const String successVehicleDeleted = 'success_vehicle_deleted';
  static const String successPropertyAdded = 'success_property_added';
  static const String successPropertyUpdated = 'success_property_updated';
  static const String successOperationCompleted = 'success_operation_completed';

}

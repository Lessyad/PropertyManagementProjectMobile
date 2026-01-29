part of 'book_property_cubit.dart';

class BookPropertyState extends Equatable {
  final List<File> selectedImages;
  final RequestState selectImagesState;
  final bool validateImages;

  final RequestState getPropertySaleDetailsState;
  final PropertySaleDetailsEntity? propertySaleDetailsEntity;
  final String getPropertySaleDetailsError;

  final RequestState bookPropertyState;
  final String bookPropertyError;
  final BookPropertyResponseEntity? bookPropertyResponse;

  final BuyerType buyerType;

  final String phoneNumber;
  final String countryCode;

  final String userName;
  final String userID;



  final bool showBirthDatePicker;
  final DateTime? birthDate;

  final bool showIDExpirationDatePicker;
  final DateTime? idExpirationDate;

  final String currentPaymentMethod;
  final String bankilyPassCode;

  BookPropertyState({
    this.selectedImages = const [],
    this.selectImagesState = RequestState.initial,
    this.validateImages = true,
    this.getPropertySaleDetailsState = RequestState.initial,
    this.propertySaleDetailsEntity,
    this.getPropertySaleDetailsError = '',
    this.bookPropertyState = RequestState.initial,
    this.bookPropertyError = '',
    this.bookPropertyResponse,
    this.buyerType = BuyerType.iAmBuyer,
    this.phoneNumber = '',
    this.countryCode = '+20',
    this.userName = '',
    this.userID = '',
    TextEditingController? phoneNumberController,
    TextEditingController? nameController,
    TextEditingController? iDNumberController,
    this.showBirthDatePicker = false,
    this.birthDate,
    this.showIDExpirationDatePicker = false,
    this.idExpirationDate,
    this.currentPaymentMethod = '',
    this.bankilyPassCode = '',
  });

  BookPropertyState copyWith({
    List<File>? selectedImages,
    RequestState? selectImagesState,
    bool? validateImages,
    RequestState? getPropertySaleDetailsState,
    PropertySaleDetailsEntity? propertySaleDetailsEntity,
    String? getPropertySaleDetailsError,
    RequestState? bookPropertyState,
    String? bookPropertyError,
    BookPropertyResponseEntity? bookPropertyResponse,
    BuyerType? buyerType,
    String? phoneNumber,
    String? countryCode,
    String? userName,
    String? userID,
    TextEditingController? phoneNumberController,
    TextEditingController? nameController,
    TextEditingController? iDNumberController,
    bool? showBirthDatePicker,
    DateTime? birthDate,
    bool? showIDExpirationDatePicker,
    DateTime? idExpirationDate,
    String? currentPaymentMethod,
    String? bankilyPassCode,
  }) {
    return BookPropertyState(
      selectedImages: selectedImages ?? this.selectedImages,
      selectImagesState: selectImagesState ?? this.selectImagesState,
      validateImages: validateImages ?? this.validateImages,
      getPropertySaleDetailsState: getPropertySaleDetailsState ?? this.getPropertySaleDetailsState,
      propertySaleDetailsEntity: propertySaleDetailsEntity ?? this.propertySaleDetailsEntity,
      getPropertySaleDetailsError: getPropertySaleDetailsError ?? this.getPropertySaleDetailsError,
      bookPropertyState: bookPropertyState ?? this.bookPropertyState,
      bookPropertyError: bookPropertyError ?? this.bookPropertyError,
      bookPropertyResponse: bookPropertyResponse ?? this.bookPropertyResponse,
      buyerType: buyerType ?? this.buyerType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      userName: userName ?? this.userName,
      userID: userID ?? this.userID,
      showBirthDatePicker: showBirthDatePicker ?? this.showBirthDatePicker,
      birthDate: birthDate ?? this.birthDate,
      showIDExpirationDatePicker: showIDExpirationDatePicker ?? this.showIDExpirationDatePicker,
      idExpirationDate: idExpirationDate ?? this.idExpirationDate,
      currentPaymentMethod: currentPaymentMethod ?? this.currentPaymentMethod,
      bankilyPassCode: bankilyPassCode ?? this.bankilyPassCode,
    );
  }

  @override
  List<Object?> get props => [
    selectedImages,
    selectImagesState,
    validateImages,
    getPropertySaleDetailsState,
    propertySaleDetailsEntity,
    getPropertySaleDetailsError,
    bookPropertyState,
    bookPropertyError,
    bookPropertyResponse,
    buyerType,
    countryCode,
    phoneNumber,
    userName,
    userID,
    showBirthDatePicker,
    birthDate,
    showIDExpirationDatePicker,
    idExpirationDate,
    currentPaymentMethod,
    bankilyPassCode,
  ];
}

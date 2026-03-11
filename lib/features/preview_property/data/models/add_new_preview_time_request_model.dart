class AddNewPreviewRequestModel {
  String? propertyId;
  String? previewTime;
  String? previewDate;
  String? paymentMethod;
  String? clientBankilyPhoneNumber;
  String? bankilyPassCode;

  AddNewPreviewRequestModel({
    this.propertyId,
    this.previewTime,
    this.previewDate,
    this.paymentMethod,
    this.clientBankilyPhoneNumber,
    this.bankilyPassCode,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'property': propertyId,
      'time': previewTime,
      'date': previewDate,
      'payment_method': paymentMethod,
    };
    if (clientBankilyPhoneNumber != null && clientBankilyPhoneNumber!.isNotEmpty) {
      map['client_bankily_phone_number'] = clientBankilyPhoneNumber;
    }
    if (bankilyPassCode != null && bankilyPassCode!.isNotEmpty) {
      map['pass_code'] = bankilyPassCode;
    }
    return map;
  }
}
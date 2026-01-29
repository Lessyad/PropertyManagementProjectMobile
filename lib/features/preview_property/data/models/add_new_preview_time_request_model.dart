class AddNewPreviewRequestModel {
  String? propertyId;
  String? previewTime;
  String? previewDate;
  String? paymentMethod;

  AddNewPreviewRequestModel({
    this.propertyId,
    this.previewTime,
    this.previewDate,
    this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'property': propertyId,
      'time': previewTime,
      'date': previewDate,
      'payment_method': paymentMethod,
    };
  }
}
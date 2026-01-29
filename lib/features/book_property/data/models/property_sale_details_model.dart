import 'package:enmaa/features/book_property/domain/entities/property_sale_details_entity.dart';
import 'package:enmaa/core/utils/number_parser.dart';

class PropertySaleDetailsModel extends PropertySaleDetailsEntity {
  const PropertySaleDetailsModel({required super.propertyPrice, required super.viewingRequestPrice, required super.bookingDeposit, required super.remainingAmount, required super.bookingDepositPercentage, required super.userBalance});

  factory PropertySaleDetailsModel.fromJson(Map<String, dynamic> json) {
    return PropertySaleDetailsModel(
      propertyPrice: NumberParser.formatDecimal(NumberParser.parseDecimalString(json['price']?.toString() ?? '0')),
      viewingRequestPrice: NumberParser.formatDecimal(NumberParser.parseDecimalString(json['viewing_request_amount']?.toString() ?? '0')),
      bookingDeposit: NumberParser.formatDecimal(NumberParser.parseDecimalString(json['booking_deposit']?.toString() ?? '0')),
      remainingAmount: NumberParser.formatDecimal(NumberParser.parseDecimalString(json['balance']?.toString() ?? '0')),
      bookingDepositPercentage: NumberParser.formatDecimal(NumberParser.parseDecimalString(json['booking_deposit_percent']?.toString() ?? '0')),
      userBalance: NumberParser.formatDecimal(NumberParser.parseDecimalString(json['user_balance']?.toString() ?? '0')),
    );
  }
}
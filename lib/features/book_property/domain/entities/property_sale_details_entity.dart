import 'package:equatable/equatable.dart';

class PropertySaleDetailsEntity extends Equatable {
  final String propertyPrice,
      viewingRequestPrice,
      bookingDeposit,
      remainingAmount, userBalance;

  final String bookingDepositPercentage;

  // TVA appliquée au prix de la propriété
  final String taxPercent, taxAmount, totalPriceWithTax;

  const PropertySaleDetailsEntity(
      {required this.propertyPrice,
      required this.viewingRequestPrice,
      required this.bookingDeposit,
      required this.remainingAmount,
      required this.bookingDepositPercentage,
      required this.userBalance,
      required this.taxPercent,
      required this.taxAmount,
      required this.totalPriceWithTax,
      });

  @override
  List<Object?> get props => [
        propertyPrice,
        viewingRequestPrice,
        bookingDeposit,
        remainingAmount,
        bookingDepositPercentage,
        userBalance,
        taxPercent,
        taxAmount,
        totalPriceWithTax,
      ];
}

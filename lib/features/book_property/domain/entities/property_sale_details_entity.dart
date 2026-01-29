import 'package:equatable/equatable.dart';

class PropertySaleDetailsEntity extends Equatable {
  final String propertyPrice,
      viewingRequestPrice,
      bookingDeposit,
      remainingAmount, userBalance;

  final String bookingDepositPercentage;

  const PropertySaleDetailsEntity(
      {required this.propertyPrice,
      required this.viewingRequestPrice,
      required this.bookingDeposit,
      required this.remainingAmount,
      required this.bookingDepositPercentage,
      required this.userBalance,
      });

  @override
  List<Object?> get props => [
        propertyPrice,
        viewingRequestPrice,
        bookingDeposit,
        remainingAmount,
        bookingDepositPercentage,
        userBalance,
      ];
}

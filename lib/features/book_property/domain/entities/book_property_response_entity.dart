import 'package:equatable/equatable.dart';

class BookPropertyResponseEntity extends Equatable {
  final String orderId;
  final String totalPrice;
  final String platformProfit;
  final String ownerPortion;
  final String paidAmount;
  final String paymentMethod;
  final String orderStatus;
  final String transactionStatus;
  final String gatewayUrl;

  const BookPropertyResponseEntity({
    required this.orderId,
    required this.totalPrice,
    required this.platformProfit,
    required this.ownerPortion,
    required this.paidAmount,
    required this.paymentMethod,
    required this.orderStatus,
    required this.transactionStatus,
    required this.gatewayUrl,
  });

  @override
  List<Object> get props => [
    orderId,
    totalPrice,
    platformProfit,
    ownerPortion,
    paidAmount,
    paymentMethod,
    orderStatus,
    transactionStatus,
    gatewayUrl,
  ];
}

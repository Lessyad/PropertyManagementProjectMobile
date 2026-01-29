import '../../domain/entities/book_property_response_entity.dart';

class BookPropertyResponseModel extends BookPropertyResponseEntity {
  const BookPropertyResponseModel({
    required super.orderId,
    required super.totalPrice,
    required super.platformProfit,
    required super.ownerPortion,
    required super.paidAmount,
    required super.paymentMethod,
    required super.orderStatus,
    required super.transactionStatus,
    required super.gatewayUrl,
  });

  factory BookPropertyResponseModel.fromJson(Map<String, dynamic> json) {
    return BookPropertyResponseModel(
      orderId: json['order_id'].toString(),
      totalPrice: json['total_price'].toString(),
      platformProfit: json['platform_profit'].toString(),
      ownerPortion: json['owner_portion'].toString(),
      paidAmount: json['paid_amount'].toString(),
      paymentMethod: json['payment_method'].toString(),
      orderStatus: json['order_status'].toString(),
      transactionStatus: json['transaction_status'].toString(),
      gatewayUrl: json['gateway_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'total_price': totalPrice,
      'platform_profit': platformProfit,
      'owner_portion': ownerPortion,
      'paid_amount': paidAmount,
      'payment_method': paymentMethod,
      'order_status': orderStatus,
      'transaction_status': transactionStatus,
      'gateway_url': gatewayUrl,
    };
  }
}

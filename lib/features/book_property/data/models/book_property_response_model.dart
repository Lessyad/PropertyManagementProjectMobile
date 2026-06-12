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
      orderId: (json['orderId'] ?? json['order_id'])?.toString() ?? '',
      totalPrice: (json['totalPrice'] ?? json['total_price'])?.toString() ?? '0',
      platformProfit: (json['platformProfit'] ?? json['platform_profit'])?.toString() ?? '0',
      ownerPortion: (json['ownerPortion'] ?? json['owner_portion'])?.toString() ?? '0',
      paidAmount: (json['paidAmount'] ?? json['paid_amount'])?.toString() ?? '0',
      paymentMethod: (json['paymentMethod'] ?? json['payment_method'])?.toString() ?? '',
      orderStatus: (json['orderStatus'] ?? json['order_status'])?.toString() ?? '',
      transactionStatus: (json['transactionStatus'] ?? json['transaction_status'])?.toString() ?? '',
      gatewayUrl: (json['gatewayUrl'] ?? json['gateway_url'])?.toString() ?? '',
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

import 'package:go_delivery_frontend/domain/entities/payment/payment.dart';

class PaymentMapper {
  static Payment fromJson(Map<String, dynamic> json) {
    return Payment(
      type: json['type'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as String? ?? '',
      debit: json['debit'] as bool,
    );
  }

  static List<Payment> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => PaymentMapper.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

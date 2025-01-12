import 'package:go_delivery_frontend/domain/entities/payment/wallet.dart';

class WalletAmountMapper {
  static WalletAmount fromJson(Map<String, dynamic> json) {
    {
      return WalletAmount(
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
        currency: json['currency'] as String? ?? 'USD',
      );
    }
  }

  static Map<String, dynamic> toJson(WalletAmount walletAmount) {
    return {
      'amount': walletAmount.amount,
      'currency': walletAmount.currency,
    };
  }
}

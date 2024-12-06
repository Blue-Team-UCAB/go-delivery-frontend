import 'package:go_delivery_frontend/domain/entities/payment/wallet.dart';

class WalletAmountMapper {
  static WalletAmount fromJson(Map<String, dynamic> json) {
    try {
      final value = json['value'] ?? {};
      return WalletAmount(
        amount: (value['amount'] as num?)?.toDouble() ?? 0.0,
        currency: value['currency'] as String? ?? 'USD',
      );
    } catch (e) {
      print('Error in WalletAmountMapper.fromJson: $e');
      rethrow;
    }
  }

  static Map<String, dynamic> toJson(WalletAmount walletAmount) {
    return {
      'amount': walletAmount.amount,
      'currency': walletAmount.currency,
    };
  }
}

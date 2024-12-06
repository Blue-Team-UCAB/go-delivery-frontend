import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/payment/wallet.dart';

abstract class WalletRepository {
  Future<Result<WalletAmount>> getWalletAmount();
}

import 'package:go_delivery_frontend/application/api/api_request.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment.dart';
import 'package:go_delivery_frontend/domain/entities/payment/wallet.dart';
import 'package:go_delivery_frontend/domain/repositories/payment/wallet_repository.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/payment/payment_mapper.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/wallet/wallet_mapper.dart';

class WalletRepositoryImpl extends WalletRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  WalletRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  Future<void> _addAuthorizationHeader() async {
    final token = await _localStorage.getAuthorizationToken();
    _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  }

  @override
  Future<Result<WalletAmount>> getWalletAmount() async {
    await _addAuthorizationHeader();

    try {
      final response = await _apiRequestManager.request(
        '/api/payment/method/user/wallet-amount',
        'GET',
        (data) => WalletAmountMapper.fromJson(data),
      );

      if (response.isSuccessful()) {
        final walletAmount = response.getValue();
        return Result.success(walletAmount);
      } else {
        return Result.fail(const ServerFailure());
      }
    } catch (e) {
      print('Error in WalletRepositoryImpl.getWalletAmount: $e');
      return Result.fail(
          ServerFailure(message: 'Fallo al obtener el monto del wallet: $e'));
    }
  }

  @override
  Future<Result<List<Payment>>> getPaymentTransactions() async {
    await _addAuthorizationHeader();

    try {
      final response = await _apiRequestManager.request(
        '/api/payment/method/user/many/transaccion',
        'GET',
        (data) => PaymentMapper.fromJsonList(data),
      );

      if (response.isSuccessful()) {
        final transactions = response.getValue();
        return Result.success(transactions);
      } else {
        return Result.fail(const ServerFailure());
      }
    } catch (e) {
      print('Error in WalletRepositoryImpl.getPaymentTransactions: $e');
      return Result.fail(
          ServerFailure(message: 'Fallo al obtener las transacciones: $e'));
    }
  }
}

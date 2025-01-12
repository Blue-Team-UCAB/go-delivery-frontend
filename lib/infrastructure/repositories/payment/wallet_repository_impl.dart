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

    final response = await _apiRequestManager.request<WalletAmount>(
      '/api/payment/method/user/wallet-amount',
      'GET',
      (data) {
        if (data is Map<String, dynamic>) {
          return WalletAmountMapper.fromJson(data);
        }
        throw FormatException('Unexpected response format');
      },
    );

    if (response.isSuccess) {
      return Result.success(response.value!);
    } else {
      return Result.fail(
          ServerFailure(message: 'Error al obtener el wallet amount'));
    }
  }

  @override
  Future<Result<List<Payment>>> getPaymentTransactions() async {
    await _addAuthorizationHeader();

    final response = await _apiRequestManager.request<List<Payment>>(
      '/api/payment/method/user/many/transaccion',
      'GET',
      (data) {
        if (data is List) {
          return PaymentMapper.fromJsonList(data);
        }
        throw FormatException('Unexpected response format');
      },
    );

    if (response.isSuccess) {
      return Result.success(response.value!);
    } else {
      return Result.fail(
          ServerFailure(message: 'Error al obtener las transacciones'));
    }
  }
}

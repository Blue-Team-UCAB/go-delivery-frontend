import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment.dart';
import 'package:go_delivery_frontend/domain/repositories/payment/wallet_repository.dart';

class GetPaymentTransactionsUseCaseInput extends IUseCaseInput {
  GetPaymentTransactionsUseCaseInput();
}

class GetPaymentTransactionsUseCase
    extends IUseCase<GetPaymentTransactionsUseCaseInput, List<Payment>> {
  final WalletRepository _walletRepository;

  GetPaymentTransactionsUseCase({required WalletRepository walletRepository})
      : _walletRepository = walletRepository;

  @override
  Future<Result<List<Payment>>> execute(
      GetPaymentTransactionsUseCaseInput params) {
    return _walletRepository.getPaymentTransactions();
  }
}

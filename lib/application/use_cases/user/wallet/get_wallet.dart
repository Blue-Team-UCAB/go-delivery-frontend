import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/payment/wallet.dart';
import 'package:go_delivery_frontend/domain/repositories/payment/wallet_repository.dart';

class GetWalletAmountUseCaseInput extends IUseCaseInput {
  GetWalletAmountUseCaseInput();
}

class GetWalletAmountUseCase
    extends IUseCase<GetWalletAmountUseCaseInput, WalletAmount> {
  final WalletRepository _walletRepository;

  GetWalletAmountUseCase({required WalletRepository walletRepository})
      : _walletRepository = walletRepository;

  @override
  Future<Result<WalletAmount>> execute(GetWalletAmountUseCaseInput params) {
    return _walletRepository.getWalletAmount();
  }
}

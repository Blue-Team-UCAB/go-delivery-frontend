import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_wallet/get_wallet_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_wallet/get_wallet_state.dart';
import 'package:go_delivery_frontend/application/use_cases/user/wallet/get_wallet.dart';

class GetWalletAmountBloc
    extends Bloc<GetWalletAmountEvent, GetWalletAmountState> {
  final GetWalletAmountUseCase _getWalletAmountUseCase;

  GetWalletAmountBloc(this._getWalletAmountUseCase)
      : super(WalletAmountInitial()) {
    on<LoadWalletAmount>(_onLoadWalletAmount);
  }

  Future<void> _onLoadWalletAmount(
    LoadWalletAmount event,
    Emitter<GetWalletAmountState> emit,
  ) async {
    emit(WalletAmountLoading());
    final result =
        await _getWalletAmountUseCase.execute(GetWalletAmountUseCaseInput());

    if (result.isSuccessful()) {
      emit(WalletAmountLoaded(result.getValue()));
    } else {
      emit(WalletAmountFailed(result));
    }
  }
}

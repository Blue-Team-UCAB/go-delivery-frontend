import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/payment/wallet.dart';

abstract class GetWalletAmountState extends Equatable {
  const GetWalletAmountState();

  @override
  List<Object?> get props => [];
}

class WalletAmountInitial extends GetWalletAmountState {}

class WalletAmountLoading extends GetWalletAmountState {}

class WalletAmountLoaded extends GetWalletAmountState {
  final WalletAmount walletAmount;

  const WalletAmountLoaded(this.walletAmount);

  @override
  List<Object?> get props => [walletAmount];
}

class WalletAmountFailed extends GetWalletAmountState {
  final Result<WalletAmount> result;

  const WalletAmountFailed(this.result);

  @override
  List<Object?> get props => [result];
}

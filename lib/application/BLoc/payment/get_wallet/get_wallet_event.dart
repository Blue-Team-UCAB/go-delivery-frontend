import 'package:equatable/equatable.dart';

abstract class GetWalletAmountEvent extends Equatable {
  const GetWalletAmountEvent();

  @override
  List<Object?> get props => [];
}

class LoadWalletAmount extends GetWalletAmountEvent {
  @override
  List<Object?> get props => [];
}

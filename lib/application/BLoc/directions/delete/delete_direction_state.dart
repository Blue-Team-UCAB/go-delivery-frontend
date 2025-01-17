import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/common/result.dart';

abstract class DeleteAddressState extends Equatable {
  const DeleteAddressState();

  @override
  List<Object?> get props => [];
}

class DeleteAddressInitial extends DeleteAddressState {}

class DeleteAddressLoading extends DeleteAddressState {}

class DeleteAddressSuccess extends DeleteAddressState {}

class DeleteAddressFailure extends DeleteAddressState {
  final Result<void> result;

  const DeleteAddressFailure(this.result);

  @override
  List<Object?> get props => [result];
}

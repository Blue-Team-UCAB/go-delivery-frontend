import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/common/result.dart';

abstract class DeleteCardState extends Equatable {
  const DeleteCardState();

  @override
  List<Object?> get props => [];
}

class DeleteCardInitial extends DeleteCardState {}

class DeleteCardLoading extends DeleteCardState {}

class DeleteCardSuccess extends DeleteCardState {}

class DeleteCardFailure extends DeleteCardState {
  final Result<void> result;

  const DeleteCardFailure(this.result);

  @override
  List<Object?> get props => [result];
}

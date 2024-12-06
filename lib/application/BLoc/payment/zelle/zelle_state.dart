import 'package:equatable/equatable.dart';

abstract class ZelleState extends Equatable {
  const ZelleState();

  @override
  List<Object?> get props => [];
}

class ZelleInitial extends ZelleState {}

class ZelleLoading extends ZelleState {}

class ZelleSuccess extends ZelleState {
  const ZelleSuccess();

  @override
  List<Object?> get props => [];
}

class ZelleFailure extends ZelleState {
  final String message;

  const ZelleFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

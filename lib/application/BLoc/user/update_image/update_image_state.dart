import 'package:equatable/equatable.dart';

abstract class UserImageState extends Equatable {
  const UserImageState();

  @override
  List<Object?> get props => [];
}

class UserImageInitial extends UserImageState {}

class UserImageLoading extends UserImageState {}

class UserImageSuccess extends UserImageState {}

class UserImageFailure extends UserImageState {
  final String message;

  const UserImageFailure(this.message);

  @override
  List<Object?> get props => [message];
}

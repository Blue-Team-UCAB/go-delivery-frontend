import 'package:equatable/equatable.dart';

abstract class CurrentUserState extends Equatable {
  const CurrentUserState();

  @override
  List<Object> get props => [];
}

class CurrentUserInitial extends CurrentUserState {}

class CurrentUserLoading extends CurrentUserState {}

class CurrentUserLoaded extends CurrentUserState {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String image;
  final String type;

  const CurrentUserLoaded({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.image,
    required this.type,
  });

  @override
  List<Object> get props => [id, email, name, phone, image, type];
}

class CurrentUserError extends CurrentUserState {
  final String message;

  const CurrentUserError(this.message);

  @override
  List<Object> get props => [message];
}
import 'package:equatable/equatable.dart';

abstract class CurrentUserEvent extends Equatable {
  const CurrentUserEvent();

  @override
  List<Object> get props => [];
}

class FetchCurrentUser extends CurrentUserEvent {}
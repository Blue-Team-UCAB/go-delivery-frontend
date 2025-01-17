import 'package:equatable/equatable.dart';

abstract class CurrentUserEvent extends Equatable {
  const CurrentUserEvent();

  @override
  List<Object> get props => [];
}

class FetchCurrentUser extends CurrentUserEvent {}

class UpdateProfileImage extends CurrentUserEvent {
  final String imageUrl;
  const UpdateProfileImage(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

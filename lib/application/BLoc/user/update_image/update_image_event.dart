import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class UserImageEvent extends Equatable {
  const UserImageEvent();
}

class UpdateUserImage extends UserImageEvent {
  final File image;

  const UpdateUserImage({required this.image});

  @override
  List<Object?> get props => [image];
}

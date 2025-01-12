import 'package:equatable/equatable.dart';

abstract class DeleteAddressEvent extends Equatable {
  const DeleteAddressEvent();

  @override
  List<Object?> get props => [];
}

class DeleteAddressRequested extends DeleteAddressEvent {
  final String addressId;

  const DeleteAddressRequested({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

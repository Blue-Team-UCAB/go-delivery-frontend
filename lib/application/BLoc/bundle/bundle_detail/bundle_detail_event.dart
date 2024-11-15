import 'package:equatable/equatable.dart';

abstract class BundleDetailEvent extends Equatable {
  const BundleDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadBundleDetail extends BundleDetailEvent {
  final String bundleId;

  const LoadBundleDetail({required this.bundleId});

  @override
  List<Object?> get props => [bundleId];
}

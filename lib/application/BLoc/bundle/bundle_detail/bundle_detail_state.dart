import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';

// Estado abstracto para el detalle de un bundle
abstract class BundleDetailState extends Equatable {
  final Bundle? bundle;

  const BundleDetailState({this.bundle});

  @override
  List<Object?> get props => [bundle];
}

class BundleDetailInitial extends BundleDetailState {}

class BundleDetailLoading extends BundleDetailState {
  const BundleDetailLoading(Bundle? bundle) : super(bundle: bundle);
}

class BundleDetailLoaded extends BundleDetailState {
  const BundleDetailLoaded(Bundle bundle) : super(bundle: bundle);

  @override
  List<Object?> get props => [bundle];
}

class BundleDetailFailed extends BundleDetailState {
  final Result<Bundle> result;

  const BundleDetailFailed(this.result);

  @override
  List<Object?> get props => [result];
}

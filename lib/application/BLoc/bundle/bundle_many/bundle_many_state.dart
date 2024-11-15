import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';

abstract class BundleListState extends Equatable {
  final List<Bundle> bundles;

  const BundleListState({this.bundles = const []});

  @override
  List<Object?> get props => [bundles];
}

class BundleListInitial extends BundleListState {}

class BundleListLoading extends BundleListState {
  const BundleListLoading(List<Bundle> bundles) : super(bundles: bundles);
}

class BundleListLoaded extends BundleListState {
  final bool hasReachedMax;
  final int page;

  const BundleListLoaded({
    required super.bundles,
    required this.hasReachedMax,
    required this.page,
  });

  BundleListLoaded copyWith({
    List<Bundle>? bundles,
    bool? hasReachedMax,
    int? page,
  }) {
    return BundleListLoaded(
      bundles: bundles ?? this.bundles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [bundles, hasReachedMax, page];
}

class BundleListFailed extends BundleListState {
  final Result<List<Bundle>> result;

  const BundleListFailed(this.result);

  @override
  List<Object?> get props => [result];
}

import 'package:equatable/equatable.dart';

abstract class BundleListEvent extends Equatable {
  const BundleListEvent();
}

class LoadBundleList extends BundleListEvent {
  final int page;
  final int perpage;

  const LoadBundleList({
    required this.page,
    required this.perpage,
  });

  @override
  List<Object?> get props => [page, perpage];
}

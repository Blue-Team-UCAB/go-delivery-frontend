import 'package:equatable/equatable.dart';

abstract class BundleListEvent extends Equatable {
  const BundleListEvent();
}

class LoadBundleList extends BundleListEvent {
  final int page;
  final int take;

  const LoadBundleList({
    required this.page,
    required this.take,
  });

  @override
  List<Object?> get props => [page, take];
}

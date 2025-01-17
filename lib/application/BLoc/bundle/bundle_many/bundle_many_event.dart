import 'package:equatable/equatable.dart';

abstract class BundleListEvent extends Equatable {
  const BundleListEvent();
}

class LoadBundleList extends BundleListEvent {
  final int page;
  final int perpage;
  final List<String>? categories;
  final String? name;
  final int? price;
  final String? popular;
  final String? discount;

  const LoadBundleList({
    required this.page,
    required this.perpage,
    this.categories,
    this.name,
    this.price,
    this.popular,
    this.discount,
  });

  @override
  List<Object?> get props => [
    page,
    perpage,
    categories,
    name,
    price,
    popular,
    discount,
  ];
}

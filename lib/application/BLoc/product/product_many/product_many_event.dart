import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();
}

class LoadProductList extends ProductListEvent {
  final int page;
  final int perpage;

  const LoadProductList({
    required this.page,
    required this.perpage,
  });

  @override
  List<Object?> get props => [page, perpage];
}

class SearchProductList extends ProductListEvent {
  final int page;
  final int perpage;
  final String search;

  const SearchProductList({
    required this.search,
    required this.page,
    required this.perpage,
  });

  @override
  List<Object?> get props => [search, page, perpage];
}

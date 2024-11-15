import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();
}

class LoadProductList extends ProductListEvent {
  final int page;
  final int take;

  const LoadProductList({
    required this.page,
    required this.take,
  });

  @override
  List<Object?> get props => [page, take];
}

class SearchProductList extends ProductListEvent {
  final int page;
  final int take;
  final String search;

  const SearchProductList({
    required this.search,
    required this.page,
    required this.take,
  });

  @override
  List<Object?> get props => [search, page, take];
}

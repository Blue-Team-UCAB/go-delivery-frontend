import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();
}

class LoadProductList extends ProductListEvent {
  final int page;
  final int take;
  final String category;

  const LoadProductList({
    required this.page,
    required this.take,
    required this.category,
  });

  @override
  List<Object?> get props => [page, take, category];
}

class SearchProductList extends ProductListEvent {
  final int page;
  final int take;
  final String search;
  final String category;

  const SearchProductList({
    required this.search,
    required this.page,
    required this.take,
    required this.category,
  });

  @override
  List<Object?> get props => [search, page, take, category];
}

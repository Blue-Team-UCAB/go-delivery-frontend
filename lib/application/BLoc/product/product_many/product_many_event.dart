import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();
}

class LoadProductList extends ProductListEvent {
  final int page;
  final int perpage;
  final String? category;

  const LoadProductList({
    required this.page,
    required this.perpage,
    required this.category,
  });

  @override
  List<Object?> get props => [page, perpage, category];
}

class SearchProductList extends ProductListEvent {
  final int page;
  final int perpage;
  final String search;
  final String? category;

  const SearchProductList({
    required this.search,
    required this.page,
    required this.perpage,
    required this.category,
  });

  @override
  List<Object?> get props => [search, page, perpage, category];
}

class ClearProductList extends ProductListEvent {
  @override
  List<Object?> get props => [];
}

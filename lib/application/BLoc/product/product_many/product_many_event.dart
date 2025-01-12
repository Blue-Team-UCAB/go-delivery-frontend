import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();
}

class LoadProductList extends ProductListEvent {
  final int page;
  final int perpage;
  final List<String>? categories;
  final String? search;
  final String? price;
  final String? discount;
  final String? popular;

  const LoadProductList({
    required this.page,
    required this.perpage,
    this.categories,
    this.search,
    this.price,
    this.discount,
    this.popular,
  });

  @override
  List<Object?> get props => [
    page,
    perpage,
    categories,
    search,
    price,
    discount,
    popular
  ];
}

class SearchProductList extends ProductListEvent {
  final int page;
  final int perpage;
  final String search;
  final List<String>? categories;
  final String? price;
  final String? discount;
  final String? popular;

  const SearchProductList({
    required this.search,
    required this.page,
    required this.perpage,
    this.categories,
    this.price,
    this.discount,
    this.popular,
  });

  @override
  List<Object?> get props => [
    search,
    page,
    perpage,
    categories,
    price,
    discount,
    popular
  ];
}

class ClearProductList extends ProductListEvent {
  @override
  List<Object?> get props => [];
}

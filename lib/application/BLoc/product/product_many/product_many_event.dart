import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();
}

class LoadProductList extends ProductListEvent {
  final int page;
  final int perpage;
  final List<String>? categories;
  final String? name;
  final String? price;
  final String? discount;
  final String? popular;

  const LoadProductList({
    required this.page,
    required this.perpage,
    this.categories,
    this.name,
    this.price,
    this.discount,
    this.popular,
  });

  @override
  List<Object?> get props => [
    page,
    perpage,
    categories,
    name,
    price,
    discount,
    popular
  ];
}

class SearchProductList extends ProductListEvent {
  final int page;
  final int perpage;
  final String name;
  final List<String>? categories;
  final String? price;
  final String? discount;
  final String? popular;

  const SearchProductList({
    required this.name,
    required this.page,
    required this.perpage,
    this.categories,
    this.price,
    this.discount,
    this.popular,
  });

  @override
  List<Object?> get props => [
    name,
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

import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

abstract class ProductListState extends Equatable {
  final List<Product> products;

  const ProductListState({this.products = const []});

  @override
  List<Object?> get props => [products];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {
  const ProductListLoading(List<Product> products) : super(products: products);
}

class ProductListLoaded extends ProductListState {
  final bool hasReachedMax;
  final int page;
  final List<String>? categories;
  final String? name;
  final String? price;
  final String? discount;
  final String? popular;

  const ProductListLoaded({
    required super.products,
    required this.hasReachedMax,
    required this.page,
    this.categories,
    this.name,
    this.price,
    this.discount,
    this.popular,
  });

  ProductListLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    int? page,
    List<String>? categories,
    String? name,
    String? price,
    String? discount,
    String? popular,
  }) {
    return ProductListLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      categories: categories ?? this.categories,
      name: name ?? this.name,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      popular: popular ?? this.popular,
    );
  }

  @override
  List<Object?> get props => [
    products,
    hasReachedMax,
    page,
    categories,
    name,
    price,
    discount,
    popular
  ];
}

class ProductListFailed extends ProductListState {
  final Result<List<Product>> result;

  const ProductListFailed(this.result);

  @override
  List<Object?> get props => [result];
}

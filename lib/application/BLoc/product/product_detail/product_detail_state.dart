import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

abstract class ProductDetailState extends Equatable {
  final Product? product;

  const ProductDetailState({this.product});

  @override
  List<Object?> get props => [product];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading(Product? product) : super(product: product);
}

class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded(Product product) : super(product: product);

  @override
  List<Object?> get props => [product];
}

class ProductDetailFailed extends ProductDetailState {
  final Result<Product> result;

  const ProductDetailFailed(this.result);

  @override
  List<Object?> get props => [result];
}

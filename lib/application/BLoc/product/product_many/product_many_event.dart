import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();
}

class LoadProductList extends ProductListEvent {
  final int page;
  final int perPage;
  final String category;

  const LoadProductList({
    required this.page,
    required this.perPage,
    required this.category,
  });

  @override
  List<Object?> get props => [page, perPage, category];
}

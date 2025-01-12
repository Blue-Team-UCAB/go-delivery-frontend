import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/application/use_cases/product/get_many_product.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_state.dart';

class ProductRandomListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase _getProductsUseCase;

  ProductRandomListBloc(this._getProductsUseCase)
      : super(ProductListInitial()) {
    on<LoadProductList>(_onLoadProductList);
  }

  Future<void> _onLoadProductList(
    LoadProductList event,
    Emitter<ProductListState> emit,
  ) async {
      emit(const ProductListLoading([]));

      final result = await _getProductsUseCase.execute(
        GetProductsUseCaseInput(
          search: '',
          page: event.page,
          perpage: event.perpage,
        ),
      );

      if (result.isSuccessful()) {
        final allProducts = result.getValue();
        final randomProducts = _getRandomProducts(allProducts, 10);

        emit(ProductListLoaded(
          products: randomProducts,
          hasReachedMax: true,
          page: event.page,
          categories: [''],
        ));
      } else {
        emit(ProductListFailed(result));
      }
  }

  List<Product> _getRandomProducts(List<Product> allProducts, int count) {
    if (allProducts.length <= count) return allProducts;

    final random = Random();
    final selectedIndices = <int>{};
    final selectedProducts = <Product>[];

    while (selectedProducts.length < count) {
      final index = random.nextInt(allProducts.length);
      if (selectedIndices.add(index)) {
        selectedProducts.add(allProducts[index]);
      }
    }

    return selectedProducts;
  }
}

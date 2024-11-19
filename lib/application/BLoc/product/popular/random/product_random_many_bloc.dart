import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/failure.dart';
import '../../../../../common/result.dart';
import '../../../../../domain/entities/product/product.dart';
import '../../../../use_cases/product/get_many_product.dart';
import '../../product_many/product_many_event.dart';
import '../../product_many/product_many_state.dart';

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
    try {
      emit(ProductListLoading([]));

      final result = await _getProductsUseCase.execute(
        GetProductsUseCaseInput(
          search: '',
          page: event.page,
          take: event.take,
        ),
      );

      if (result.isSuccessful()) {
        final allProducts = result.getValue();
        final randomProducts = _getRandomProducts(allProducts, 10);

        emit(ProductListLoaded(
          products: randomProducts,
          hasReachedMax: true,
          page: event.page,
          category: '',
        ));
      } else {
        emit(ProductListFailed(result));
      }
    } catch (e) {
      print('Error in ProductRandomListBloc: $e');
      emit(ProductListFailed(Result.fail(e.toString() as Failure)));
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

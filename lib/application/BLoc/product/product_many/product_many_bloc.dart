import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/product/get_many_product.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase _getProductsUseCase;

  ProductListBloc(this._getProductsUseCase) : super(ProductListInitial()) {
    on<LoadProductList>(_onLoadProductList);
  }

  Future<void> _onLoadProductList(
    LoadProductList event,
    Emitter<ProductListState> emit,
  ) async {
    if (state is ProductListInitial || state is ProductListLoaded) {
      emit(ProductListLoading(state.products));

      final result = await _getProductsUseCase.execute(
        GetProductsUseCaseInput(
          page: event.page,
          take: event.take,
          category: event.category,
        ),
      );

      if (result.isSuccessful()) {
        final newProducts = result.getValue();
        emit(ProductListLoaded(
          products: [...state.products, ...newProducts],
          hasReachedMax: newProducts.isEmpty,
          page: event.page,
        ));
      } else {
        emit(ProductListFailed(result));
      }
    }
  }
}

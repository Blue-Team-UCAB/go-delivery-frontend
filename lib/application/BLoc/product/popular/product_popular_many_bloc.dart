import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/application/use_cases/product/get_many_product.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_state.dart';

class ProductPopularListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase _getProductsUseCase;

  ProductPopularListBloc(this._getProductsUseCase)
      : super(ProductListInitial()) {
    on<LoadProductList>(_onLoadProductList);
  }

  Future<void> _onLoadProductList(
    LoadProductList event,
    Emitter<ProductListState> emit,
  ) async {
    if (state is ProductListInitial || state is ProductListLoaded) {
      try {
        final currentState = state is ProductListLoaded
            ? state
            : const ProductListLoaded(
                products: [], hasReachedMax: false, page: 1);

        emit(ProductListLoading(currentState.products));

        final result = await _getProductsUseCase.execute(
          GetProductsUseCaseInput(
            name: '',
            categories: [''],
            price: 0,
            discount: '',
            popular: '',
            page: event.page,
            perpage: event.perpage,
          ),
        );

        if (result.isSuccessful()) {
          final newProducts = result.getValue();
          final hasReachedMax = newProducts.isEmpty;

          emit(ProductListLoaded(
            products: [...newProducts],
            hasReachedMax: hasReachedMax,
            page: event.page,
            categories: [''],
          ));
        } else {
          emit(ProductListFailed(result));
        }
      } catch (e) {
        print('Error in ProductListBloc: $e');
        emit(ProductListFailed(Result.fail(e.toString() as Failure)));
      }
    }
  }
}

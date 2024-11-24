import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/application/use_cases/product/get_many_product.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase _getProductsUseCase;

  ProductListBloc(this._getProductsUseCase) : super(ProductListInitial()) {
    on<LoadProductList>(_onLoadProductList);
    on<SearchProductList>(_onSearchProductList);
    on<ClearProductList>(_onClearProductList);
  }

  Future<void> _onLoadProductList(
    LoadProductList event,
    Emitter<ProductListState> emit,
  ) async {
    await _loadProducts(
      '',
      event.category,
      event.page,
      event.take,
      emit,
    );
  }

  Future<void> _onSearchProductList(
    SearchProductList event,
    Emitter<ProductListState> emit,
  ) async {
    await _loadProducts(
      event.search,
      event.category,
      event.page,
      event.take,
      emit,
    );
  }

  Future<void> _onClearProductList(
    ClearProductList event,
    Emitter<ProductListState> emit,
  ) async {
    emit(const ProductListLoading([]));
  }

  Future<void> _loadProducts(
    String? search,
    String? category,
    int page,
    int take,
    Emitter<ProductListState> emit,
  ) async {
    try {
      final currentState = state is ProductListLoaded
          ? state as ProductListLoaded
          : const ProductListLoaded(
              products: [], hasReachedMax: false, page: 1, category: '');
      if (currentState.category != category) {
        emit(const ProductListLoading([]));
      }

      final result = await _getProductsUseCase.execute(
        GetProductsUseCaseInput(
          page: page,
          take: take,
          category: category,
          search: search,
        ),
      );

      if (result.isSuccessful()) {
        final newProducts = result.getValue();
        final hasReachedMax = newProducts.isEmpty;

        emit(ProductListLoaded(
          products: page == 1
              ? newProducts
              : [...currentState.products, ...newProducts],
          hasReachedMax: hasReachedMax,
          page: page,
          category: category ?? '',
        ));
      } else {
        emit(ProductListFailed(result));
      }
    } catch (e) {
      emit(ProductListFailed(Result.fail(const ServerFailure())));
    }
  }
}

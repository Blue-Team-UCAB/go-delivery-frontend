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
  }

  Future<void> _onLoadProductList(
      LoadProductList event,
      Emitter<ProductListState> emit,
      ) async {
    await _loadProducts('', event.page, event.perpage, emit);
  }

  Future<void> _onSearchProductList(
      SearchProductList event,
      Emitter<ProductListState> emit,
      ) async {
    await _loadProducts(event.search,event.page, event.perpage, emit);
  }

  Future<void> _loadProducts(
      String? search,
      int page,
      int perpage,
      Emitter<ProductListState> emit,
      ) async {
    try {
      print('Debug: Entering _loadProducts method');
      print('Debug: search: $search, page: $page, take: $perpage');

      final currentState = state is ProductListLoaded
          ? state as ProductListLoaded
          : const ProductListLoaded(products: [], hasReachedMax: false, page: 1);

      print('Debug: Current state: $currentState');
      emit(ProductListLoading(currentState.products));

      print('Debug: Calling _getProductsUseCase.execute');
      final result = await _getProductsUseCase.execute(
        GetProductsUseCaseInput(
          page: page,
          perpage: perpage,
          search: search,
        ),
      );

      print('Debug: Result received: $result');

      if (result == null) {
        print('Error: Result is null');
        emit(ProductListFailed(Result.fail(const ServerFailure())));
        return;
      }

      if (result.isSuccessful()) {
        print('Debug: Result is successful');
        final newProducts = result.getValue();

        if (newProducts == null) {
          print('Error: New products are null');
          emit(ProductListFailed(Result.fail(const ServerFailure())));
          return;
        }

        print('Debug: New products count: ${newProducts.length}');
        final hasReachedMax = newProducts.isEmpty;

        emit(ProductListLoaded(
          products: page == 1 ? newProducts : [...currentState.products, ...newProducts],
          hasReachedMax: hasReachedMax,
          page: page,
        ));
      } else {
        print('Debug: Result is not successful');
        emit(ProductListFailed(result));
      }
    } catch (e) {
      print('Error in ProductListBloc: $e');
      print('Stack trace: ${StackTrace.current}');
      emit(ProductListFailed(Result.fail(const ServerFailure())));
    }
  }
}

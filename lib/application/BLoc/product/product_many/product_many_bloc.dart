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
    await _loadProducts(
      name: event.name ?? '',
      categories: event.categories ?? [''],
      price: event.price ?? 0,
      discount: event.discount ?? '',
      popular: event.popular ?? '',
      page: event.page,
      perPage: event.perpage,
      emit: emit,
    );
  }

  Future<void> _onSearchProductList(
    SearchProductList event,
    Emitter<ProductListState> emit,
  ) async {
    await _loadProducts(
      name: event.name,
      categories: event.categories ?? [''],
      price: event.price ?? 0,
      discount: event.discount ?? '',
      popular: event.popular ?? '',
      page: event.page,
      perPage: event.perpage,
      emit: emit,
    );
  }

  Future<void> _loadProducts({
    String name = '',
    List<String> categories = const [''],
    int price = 0,
    String discount = '',
    String popular = '',
    required int page,
    required int perPage,
    required Emitter<ProductListState> emit,
  }) async {
    try {
      // Determine the current state
      final currentState = state is ProductListLoaded
          ? state as ProductListLoaded
          : ProductListLoaded(
              products: [],
              hasReachedMax: false,
              page: 1,
              name: name,
              categories: categories,
              price: price,
              discount: discount,
              popular: popular,
            );

      // Check if we need to reset the list
      final shouldResetList = (name != currentState.name) ||
          (categories != currentState.categories) ||
          (price != currentState.price) ||
          (discount != currentState.discount) ||
          (popular != currentState.popular);

      // Prepare initial state if resetting
      if (shouldResetList) {
        emit(ProductListLoaded(
          products: [],
          hasReachedMax: false,
          page: 1,
          name: name,
          categories: categories,
          price: price,
          discount: discount,
          popular: popular,
        ));
      }

      // Prepare input for use case
      final input = GetProductsUseCaseInput(
        page: page,
        perpage: perPage,
        name: name,
        categories: categories,
        price: price,
        discount: discount, // Ensure this line is present
        popular: popular,
      );

      // Execute use case
      final result = await _getProductsUseCase.execute(input);

      if (result.isSuccessful()) {
        final newProducts = result.getValue();
        final hasReachedMax = newProducts.isEmpty;

        emit(ProductListLoaded(
          products: page == 1 || shouldResetList
              ? newProducts
              : [...currentState.products, ...newProducts],
          hasReachedMax: hasReachedMax,
          page: page,
          name: name,
          categories: categories,
          price: price,
          discount: discount,
          popular: popular,
        ));
      } else {
        emit(ProductListFailed(result));
      }
    } catch (e) {
      emit(ProductListFailed(Result.fail(const ServerFailure())));
    }
  }
}

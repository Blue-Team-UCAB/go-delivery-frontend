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
    on<SearchProductList>(_onSearchProductList);
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
            categories: event.categories ?? [],
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
            categories: event.categories ?? [],
          ));
        } else {
          emit(ProductListFailed(result));
        }
      } catch (e) {
        emit(ProductListFailed(Result.fail(e.toString() as Failure)));
      }
    }
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
      // Emitir estado de cargando con los productos actuales
      if (state is ProductListLoaded) {
        final currentState = state as ProductListLoaded;
        emit(ProductListLoading(currentState.products));
      } else {
        emit(ProductListLoading([]));
      }

      // Determinar el estado actual
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

      // Verificar si se deben reiniciar los productos
      final shouldResetList = (name != currentState.name) ||
          (categories != currentState.categories) ||
          (price != currentState.price) ||
          (discount != currentState.discount) ||
          (popular != currentState.popular);

      // Emitir un estado limpio si los filtros cambian
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

      // Ejecutar el caso de uso
      final result = await _getProductsUseCase.execute(
        GetProductsUseCaseInput(
          name: name,
          categories: categories,
          price: price,
          discount: discount,
          popular: popular,
          page: page,
          perpage: perPage,
        ),
      );

      if (result.isSuccessful()) {
        final allProducts = result.getValue();
        final randomProducts = _getRandomProducts(allProducts, 10);
        final hasReachedMax = randomProducts.isEmpty;

        emit(ProductListLoaded(
          products: page == 1 || shouldResetList
              ? randomProducts
              : [...currentState.products, ...randomProducts],
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

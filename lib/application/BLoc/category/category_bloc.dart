import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_event.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_state.dart';
import 'package:go_delivery_frontend/application/use_cases/category/get_many_category.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoryBloc(this._getCategoriesUseCase) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<SearchCategories>(_onSearchCategories);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    await _loadCategories(
      name: event.name ?? '',
      page: event.page,
      perPage: event.perpage,
      emit: emit,
    );
  }

  Future<void> _onSearchCategories(
    SearchCategories event,
    Emitter<CategoryState> emit,
  ) async {
    await _loadCategories(
      name: event.name,
      page: event.page,
      perPage: event.perpage,
      emit: emit,
    );
  }

  Future<void> _loadCategories({
    String name = '',
    required int page,
    required int perPage,
    required Emitter<CategoryState> emit,
  }) async {
    try {
      final currentState = state is CategoryLoaded
          ? state as CategoryLoaded
          : CategoryLoaded(
              categories: [],
              hasReachedMax: false,
              page: 1,
              name: name,
            );

      final shouldResetList = (name != currentState.name);
      if (shouldResetList) {
        emit(CategoryLoaded(
          categories: [],
          hasReachedMax: false,
          page: 1,
          name: name,
        ));
      }

      final result = await _getCategoriesUseCase.execute(GetCategoriesInput(
        name: name,
        page: page,
        perpage: perPage,
      ));

      if (result.isSuccessful()) {
        final newCategories = result.getValue();
        final hasReachedMax = newCategories.isEmpty;
        emit(CategoryLoaded(
          categories: newCategories.isNotEmpty
              ? newCategories
              : currentState.categories,
          hasReachedMax: hasReachedMax,
          page: page,
          name: name,
        ));
      } else {
        emit(CategoryFailed(result.getError().message));
      }
    } catch (e) {
      emit(CategoryFailed(e.toString()));
    }
  }

  Future<void> _onSelectCategory(
    SelectCategory event,
    Emitter<CategoryState> emit,
  ) async {
    final currentState = state is CategoryLoaded
        ? state as CategoryLoaded
        : CategoryLoaded(
            categories: [],
            hasReachedMax: false,
            page: 1,
            name: null,
          );

    final categoryName = event.categoryName;

    emit(CategoryLoaded(
      categories: currentState.categories,
      hasReachedMax: currentState.hasReachedMax,
      page: currentState.page,
      name: categoryName,
    ));
  }
}

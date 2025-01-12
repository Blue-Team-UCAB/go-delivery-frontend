import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/category/get_many_category.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoryBloc({required GetCategoriesUseCase getCategoriesUseCase})
      : _getCategoriesUseCase = getCategoriesUseCase,
        super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(CategoryLoading());

      final result = await _getCategoriesUseCase.execute(
        GetCategoriesInput(
          page: event.page,
          perpage: event.perpage,
        ),
      );

      if (result.isSuccessful()) {
        final categories = result.getValue();
        print('Loaded categories: ${categories.length}'); // Debug print
        emit(CategoryLoaded(categories));
      } else {
        emit(CategoryError(result.getError().message));
      }
    } catch (e) {
      print('Error loading categories: $e'); // Debug print
      emit(CategoryError(e.toString()));
    }
  }
}

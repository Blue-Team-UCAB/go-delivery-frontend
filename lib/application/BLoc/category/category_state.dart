part of 'category_bloc.dart';

// category_state.dart
abstract class CategoryState {
  const CategoryState();
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

// In category_state.dart or as part of your bloc file
class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  const CategoryLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);
}

part of 'category_bloc.dart';

// category_event.dart
abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {
  // final String? search;
  final String? category;
  final int page;
  final int perpage;

  LoadCategories({
    // this.search,
    this.category,
    this.page = 1,
    this.perpage = 10,
  });
}

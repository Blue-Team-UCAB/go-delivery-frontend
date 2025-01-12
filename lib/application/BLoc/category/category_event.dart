part of 'category_bloc.dart';

// category_event.dart
abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {
  final String? name;
  final int page;
  final int perpage;

  LoadCategories({
    this.name,
    this.page = 1,
    this.perpage = 10,
  });
}

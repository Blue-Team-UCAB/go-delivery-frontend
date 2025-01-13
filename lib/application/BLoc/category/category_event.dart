import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  final int page;
  final int perpage;
  final String? name;

  const LoadCategories({
    required this.page,
    required this.perpage,
    this.name,
  });

  @override
  List<Object?> get props => [page, perpage, name];
}

class SearchCategories extends CategoryEvent {
  final int page;
  final int perpage;
  final String name;

  const SearchCategories({
    required this.name,
    required this.page,
    required this.perpage,
  });

  @override
  List<Object?> get props => [name, page, perpage];
}

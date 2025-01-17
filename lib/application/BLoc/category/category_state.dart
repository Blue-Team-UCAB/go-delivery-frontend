import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  final bool hasReachedMax;
  final int page;
  final String? name;

  const CategoryLoaded({
    required this.categories,
    required this.hasReachedMax,
    required this.page,
    this.name,
  });

  @override
  List<Object?> get props => [categories, hasReachedMax, page, name];
}

class CategoryFailed extends CategoryState {
  final String message;

  const CategoryFailed(this.message);

  @override
  List<Object?> get props => [message];
}

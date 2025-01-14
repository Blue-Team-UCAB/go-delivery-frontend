import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';

// Events
abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class UpdateCategory extends FilterEvent {
  final String? category;

  const UpdateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateDiscount extends FilterEvent {
  final bool hasDiscount;

  const UpdateDiscount(this.hasDiscount);

  @override
  List<Object?> get props => [hasDiscount];
}

class UpdatePriceRange extends FilterEvent {
  final RangeValues priceRange;

  const UpdatePriceRange(this.priceRange);

  @override
  List<Object?> get props => [priceRange];
}

class UpdateCategories extends FilterEvent {
  final List<Category> categories;

  const UpdateCategories(this.categories);

  @override
  List<Object?> get props => [categories];
}

// States
class FilterState extends Equatable {
  final String? selectedCategory;
  final bool hasDiscount;
  final RangeValues priceRange;
  final List<Category> categories;

  const FilterState({
    this.selectedCategory,
    this.hasDiscount = false,
    this.priceRange = const RangeValues(90, 200),
    this.categories = const [],
  });

  FilterState copyWith({
    String? selectedCategory,
    bool? hasDiscount,
    RangeValues? priceRange,
    List<Category>? categories,
  }) {
    return FilterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      hasDiscount: hasDiscount ?? this.hasDiscount,
      priceRange: priceRange ?? this.priceRange,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props =>
      [selectedCategory, hasDiscount, priceRange, categories];
}

// BLoC
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState()) {
    on<UpdateCategory>((event, emit) {
      emit(state.copyWith(selectedCategory: event.category));
    });

    on<UpdateDiscount>((event, emit) {
      emit(state.copyWith(hasDiscount: event.hasDiscount));
    });

    on<UpdatePriceRange>((event, emit) {
      emit(state.copyWith(priceRange: event.priceRange));
    });

    on<UpdateCategories>((event, emit) {
      emit(state.copyWith(categories: event.categories));
    });
  }
}

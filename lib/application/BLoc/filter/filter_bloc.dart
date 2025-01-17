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

// Remove UpdateCategory event

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

class ResetFilters extends FilterEvent {} // Add this line

class UpdateSelectedCategories extends FilterEvent {
  final List<String> selectedCategories;

  const UpdateSelectedCategories(this.selectedCategories);

  @override
  List<Object?> get props => [selectedCategories];
}

// States
class FilterState extends Equatable {
  // Remove selectedCategory field
  final bool hasDiscount;
  final RangeValues priceRange;
  final List<Category> categories;
  final List<String> selectedCategories;

  const FilterState({
    // Remove selectedCategory parameter
    this.hasDiscount = false,
    this.priceRange = const RangeValues(0, 30), // Modify this line
    this.categories = const [],
    this.selectedCategories = const [],
  });

  FilterState copyWith({
    // Remove selectedCategory parameter
    bool? hasDiscount,
    RangeValues? priceRange,
    List<Category>? categories,
    List<String>? selectedCategories,
  }) {
    return FilterState(
      // Remove selectedCategory assignment
      hasDiscount: hasDiscount ?? this.hasDiscount,
      priceRange: priceRange ?? this.priceRange,
      categories: categories ?? this.categories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }

  @override
  List<Object?> get props => [
        // Remove selectedCategory from props
        hasDiscount,
        priceRange,
        categories,
        selectedCategories
      ];
}

// BLoC
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState()) {
    // Remove UpdateCategory handler

    on<UpdateDiscount>((event, emit) {
      emit(state.copyWith(hasDiscount: event.hasDiscount));
    });

    on<UpdatePriceRange>((event, emit) {
      emit(state.copyWith(priceRange: event.priceRange));
    });

    on<UpdateCategories>((event, emit) {
      emit(state.copyWith(categories: event.categories));
    });

    on<ResetFilters>((event, emit) {
      emit(const FilterState());
    });

    on<UpdateSelectedCategories>((event, emit) {
      emit(state.copyWith(selectedCategories: event.selectedCategories));
    });
  }
}

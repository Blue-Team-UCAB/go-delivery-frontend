import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_event.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_state.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';

import 'package:go_delivery_frontend/presentation/core/theme/theme_getter.dart';

class CategoryTabs extends StatefulWidget {
  final Function(List<String>)? onCategorySelected;
  final List<String> selectedCategories; // Add this field

  const CategoryTabs({
    super.key,
    this.onCategorySelected,
    required this.selectedCategories, // Add this parameter
  });

  @override
  CategoryTabsState createState() => CategoryTabsState();
}

class CategoryTabsState extends State<CategoryTabs> {
  late List<String> _selectedCategories; // Change this to late

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(
        widget.selectedCategories); // Initialize with widget.selectedCategories
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(LoadCategories(page: 1, perpage: 10));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return _buildLoadingTabs();
        }

        if (state is CategoryFailed) {
          return _buildErrorTabs();
        }

        if (state is CategoryLoaded) {
          return _buildLoadedTabs(state.categories, context);
        }

        return _buildLoadingTabs();
      },
    );
  }

  Widget _buildLoadingTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 16),
            ...List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Loading...'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 16),
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Error loading categories'),
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<CategoryBloc>()
                    .add(LoadCategories(page: 1, perpage: 10));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedTabs(List<Category> categories, BuildContext context) {
    final allCategories = [
      // Category(id: '', name: 'Todo', imageUrl: ''),
      ...categories,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 16),
            ...List.generate(
              allCategories.length,
              (index) => _buildTab(
                  allCategories[index],
                  _selectedCategories.contains(allCategories[index].name),
                  index,
                  context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
      Category category, bool isSelected, int index, BuildContext context) {
    final currentSecondaryThemeColor =
        AppThemesGetter.getSecondaryColor(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedCategories.contains(category.name)) {
            _selectedCategories.remove(category.name);
          } else {
            _selectedCategories.add(category.name);
          }
        });
        widget.onCategorySelected?.call(_selectedCategories);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? currentSecondaryThemeColor : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Text(
          category.name,
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_bloc.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';

class CategoryTabs extends StatefulWidget {
  final Function(String?)? onCategorySelected;

  const CategoryTabs({
    super.key,
    this.onCategorySelected,
  });

  @override
  CategoryTabsState createState() => CategoryTabsState();
}

class CategoryTabsState extends State<CategoryTabs> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load categories when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(LoadCategories(page: 1, perpage: 10));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        print('Current state: $state'); // Debug print

        if (state is CategoryLoading) {
          return _buildLoadingTabs();
        }

        if (state is CategoryError) {
          return _buildErrorTabs();
        }

        if (state is CategoryLoaded) {
          return _buildLoadedTabs(state.categories);
        }

        return _buildLoadingTabs(); // Show loading for initial state
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

  Widget _buildLoadedTabs(List<Category> categories) {
    final allCategories = [
      Category(id: '', name: 'Todo', imageUrl: ''),
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
                  allCategories[index], index == _selectedIndex, index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(Category category, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onCategorySelected?.call(index == 0 ? null : category.id);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2000B1) : const Color(0xFFFFFFFF),
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

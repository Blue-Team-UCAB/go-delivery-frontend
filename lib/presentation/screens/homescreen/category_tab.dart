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
    // Asegurarse de que las categorías estén cargadas
    if (context.read<CategoryBloc>().state is! CategoryLoaded) {
      context.read<CategoryBloc>().add(LoadCategories());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[(index % 2 == 0) ? 300 : 400],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Loading...',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.grey[600],
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )),
              ),
            ),
          );
        }

        if (state is CategoryError) {
          final fakeCategories = [
            Category(id: '1', name: 'Tag 1', imageUrl: ''),
            Category(id: '2', name: 'Tag 2', imageUrl: ''),
            Category(id: '3', name: 'Tag 3', imageUrl: ''),
          ];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  for (int i = 0; i < fakeCategories.length; i++)
                    _buildTab(fakeCategories[i], i == _selectedIndex, i),
                ],
              ),
            ),
          );
        }

        if (state is CategoryLoaded) {
          // Agregar "Todo" al principio de la lista
          final List<Category> categories = [
            Category(id: '', name: 'Todo', imageUrl: ''),
            ...state.categories
          ];

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  for (int i = 0; i < categories.length; i++)
                    _buildTab(categories[i], i == _selectedIndex, i),
                ],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget _buildTab(Category category, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        // Llamar al callback con el ID de la categoría (null para "Todo")
        widget.onCategorySelected?.call(
          index == 0 ? null : category.id,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2000B1) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
          // Agregar sombra sutil
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

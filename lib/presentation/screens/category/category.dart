import 'package:go_delivery_frontend/application/BLoc/category/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/navbar.dart';
import 'package:go_router/go_router.dart';

// categories_screen.dart
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar las categorías cuando se inicia la pantalla
    context.read<CategoryBloc>().add(LoadCategories());
  }

  int _counter = 0;
  // Función para manejar el cambio de tab
  void _onNavItemTapped(int valueIndex) {
    setState(() {
      _counter = valueIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas las categorías'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              context.push('/notification');
            },
          ),
        ],
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryError) {
            final fakeCategories = [
              {'imageUrl': '', 'name': 'Fake Category 1'},
              {'imageUrl': '', 'name': 'Fake Category 2'},
              {'imageUrl': '', 'name': 'Fake Category 3'},
            ];
            return Stack(
              children: [
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: fakeCategories.length,
                  itemBuilder: (context, index) {
                    final category = fakeCategories[index];
                    return CategoryCard(
                      imageUrl: category['imageUrl']!,
                      title: category['name']!,
                    );
                  },
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CategoryBloc>().add(LoadCategories());
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          if (state is CategoryLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return CategoryCard(
                  imageUrl: category.imageUrl,
                  title: category.name,
                );
              },
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _counter,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const CategoryCard({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepOrange,
            radius: 30,
            child: imageUrl.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.label, color: Colors.white),
                    ),
                  )
                : const Icon(Icons.label, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

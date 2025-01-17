import 'package:go_delivery_frontend/application/BLoc/category/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_event.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_state.dart';
import 'package:go_delivery_frontend/presentation/widgets/navbar.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategories(page: 1, perpage: 10));
  }

  int _counter = 0;
  void _onNavItemTapped(int valueIndex) {
    setState(() {
      _counter = valueIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEBEAED),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Todas las categorías',
            style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                fontSize: 26)),
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

          if (state is CategoryFailed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<CategoryBloc>()
                          .add(LoadCategories(page: 1, perpage: 10));
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is CategoryLoaded) {
            if (state.categories.isEmpty) {
              return const Center(
                child: Text('No hay categorías disponibles'),
              );
            }
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
                return GestureDetector(
                  onTap: () {
                    context.push('/catalog', extra: category.name);
                  },
                  child: CategoryCard(
                    image: category.imageUrl ?? '',
                    title: category.name,
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
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
  final String image;
  final String title;

  const CategoryCard({
    super.key,
    required this.image,
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
            child: image.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      image,
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

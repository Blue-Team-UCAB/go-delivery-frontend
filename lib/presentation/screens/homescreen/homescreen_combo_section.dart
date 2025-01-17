import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_state.dart';
import 'package:go_delivery_frontend/presentation/widgets/bundle_card.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_state.dart';
import 'package:go_delivery_frontend/presentation/widgets/homescreen/bundle_section_placeholder.dart';


class ComboSection extends StatefulWidget {
  final List<String>? selectedCategories;

  const ComboSection({super.key, required this.selectedCategories});

  @override
  State<ComboSection> createState() => _ComboSectionState();
}

class _ComboSectionState extends State<ComboSection> {
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    selectedCategories = widget.selectedCategories ?? [];
    BlocProvider.of<BundleListBloc>(context).add(
      LoadBundleList(page: 1, perpage: 4, categories: selectedCategories),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryLoaded) {
          setState(() {
            selectedCategories = state.name != null ? [state.name!] : [];
          });

          // Llamamos a LoadBundleList cuando la categoría cambia
          BlocProvider.of<BundleListBloc>(context).add(
            LoadBundleList(
              page: 1,
              perpage: 4,
              categories: selectedCategories,
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Combos ofertados',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const CircularProgressIndicator();
              }
              if (state is CategoryFailed) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              if (state is CategoryLoaded) {
                return const SizedBox(); // Ya no se muestran los ChoiceChip
              }
              return const SizedBox();
            },
          ),
          const SizedBox(height: 16),
          BlocBuilder<BundleListBloc, BundleListState>(
              builder: (context, state) {
            if (state is BundleListLoading) {
              return const BundleSectionPlaceholder();
            }
            if (state is BundleListFailed) {
              return Center(
                child: Text(
                  'Error: ${state.result}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (state is BundleListLoaded) {
              final bundles = state.bundles;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var bundle in bundles)
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            height: 280,
                            child: BundleCard(bundle: bundle),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                  ],
                ),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }
}

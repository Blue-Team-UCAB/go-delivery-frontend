import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/filter/filter_bloc.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/category_tab.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  FilterSheetState createState() => FilterSheetState();
}

class FilterSheetState extends State<FilterSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filtro de Búsqueda',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 32),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),

              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Con descuento',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Switch(
                    value: state.hasDiscount,
                    onChanged: (value) {
                      context.read<FilterBloc>().add(UpdateDiscount(value));
                    },
                    activeColor: const Color(0xFF2000B1),
                    inactiveThumbColor:
                        const Color(0xFF2000B1).withOpacity(0.3),
                    inactiveTrackColor:
                        const Color(0xFF2000B1).withOpacity(0.1),
                  ),
                ],
              ),

              SizedBox(height: 32),

              Text('Categorías',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              CategoryTabs(
                selectedCategories: state.selectedCategories, // Add this
                onCategorySelected: (List<String> selectedCategories) {
                  context
                      .read<FilterBloc>()
                      .add(UpdateSelectedCategories(selectedCategories));
                },
              ),
              SizedBox(height: 32),
              Text('Precio',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              RangeSlider(
                values: state.priceRange,
                min: 0,
                max: 30,
                divisions: 300, // Increase divisions for more precision
                labels: RangeLabels(
                    '\$${state.priceRange.start.toStringAsFixed(2)}',
                    '\$${state.priceRange.end.toStringAsFixed(2)}'),
                onChanged: (RangeValues values) {
                  context.read<FilterBloc>().add(UpdatePriceRange(values));
                },
                activeColor: const Color(0xFF2000B1), // Change the active color
                inactiveColor: const Color(0xFF2000B1)
                    .withOpacity(0.3), // Change the inactive color
              ),

              // Buttons
              SizedBox(height: 40),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      context.read<FilterBloc>().add(ResetFilters());
                      Navigator.pop(context, <String,
                          dynamic>{}); // Return a Map instead of an empty string
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: const Color(0xFF2000B1)),
                    ),
                    child: Text(
                      'Limpiar',
                      style: TextStyle(color: const Color(0xFF2000B1)),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          // 'category': state.selectedCategory, // Remove this
                          'priceRange': state.priceRange,
                          'hasDiscount': state.hasDiscount,
                          'selectedCategories':
                              state.selectedCategories, // Add this line
                        }); // Modify this line
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2000B1),
                      ),
                      child: Text(
                        'Aplicar filtros',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

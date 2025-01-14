import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/filter/filter_bloc.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/category_tab.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Set the modal to fit its content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                      Navigator.of(context).pop(); // Close the modal
                    },
                  ),
                ],
              ),

              SizedBox(height: 32),
              // Discount Switch
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
                    activeColor:
                        const Color(0xFF2000B1), // Change the active color
                    inactiveThumbColor: const Color(0xFF2000B1)
                        .withOpacity(0.3), // Change the inactive thumb color
                    inactiveTrackColor: const Color(0xFF2000B1)
                        .withOpacity(0.1), // Change the inactive track color
                  ),
                ],
              ),

              SizedBox(height: 32),
              // Categories
              Text('Categorías',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              CategoryTabs(
                onCategorySelected: (String? categoryId) {
                  context.read<FilterBloc>().add(UpdateCategory(categoryId));
                },
              ),
              // Price Range
              SizedBox(height: 32),
              Text('Precio',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              RangeSlider(
                values: state.priceRange,
                min: 0,
                max: 500,
                divisions: 50, // Increase divisions for more precision
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
                    onPressed: () {},
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
                        Navigator.pop(context,
                            state.selectedCategory); // Modify this line
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

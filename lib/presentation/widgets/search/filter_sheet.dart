import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/category_tab.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  bool hasDiscount = false;
  RangeValues priceRange = RangeValues(90, 200);
  String? _selectedCategory; // Add this line

  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Switch(
                value: hasDiscount,
                onChanged: (value) => setState(() => hasDiscount = value),
                activeColor: const Color(0xFF2000B1), // Change the active color
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
              setState(() {
                _selectedCategory = categoryId; // Add this line
              });
            },
          ),
          // Price Range
          SizedBox(height: 32),
          Text('Precio',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          RangeSlider(
            values: priceRange,
            min: 0,
            max: 500,
            divisions: 10,
            labels: RangeLabels(
                '\$${priceRange.start.round()}', '\$${priceRange.end.round()}'),
            onChanged: (RangeValues values) {
              setState(() => priceRange = values);
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
                    Navigator.pop(
                        context, _selectedCategory); // Modify this line
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
  }
}

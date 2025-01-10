import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  bool hasDiscount = false;
  RangeValues priceRange = RangeValues(90, 200);

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
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the modal
                },
              ),
            ],
          ),

          // Discount Switch
          SwitchListTile(
            title: Text('Con descuento'),
            value: hasDiscount,
            onChanged: (value) => setState(() => hasDiscount = value),
          ),

          // Categories
          Text('Categorías',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text('Todo'),
                selected: true,
                onSelected: (bool selected) {},
              ),
              FilterChip(
                label: Text('Hogar'),
                selected: false,
                onSelected: (bool selected) {},
              ),
              // Add more chips...
            ],
          ),

          // Price Range
          SizedBox(height: 16),
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
          ),

          // Buttons
          SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton(
                child: Text('Limpiar'),
                onPressed: () {},
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  child: Text('Aplicar filtros'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2000B1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

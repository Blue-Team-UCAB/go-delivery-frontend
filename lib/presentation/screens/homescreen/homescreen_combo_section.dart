import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComboSection extends StatelessWidget {
  const ComboSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Combos ofertados',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ver todos',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Color(0xFF2000B1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Constrained ListView with SizedBox
          SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 2, // Replace with your actual combo item count
              itemBuilder: (context, index) {
                // Replace with your logic to create ComboCard instances
                if (index == 0) {
                  return const ComboCard(
                    title: 'Combo ',
                    price: '100.00',
                    description: 'A delicious combo',
                    imageUrl: 'assets/combo1.png', // Replace with actual asset path
                  );
                } else {
                  return const ComboCard(
                    title: 'Fabulous Pants',
                    price: '15.00',
                    description: 'Another description',
                    imageUrl: 'assets/combo2.png', // Replace with actual asset path
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ComboCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final String imageUrl;
  final String defaultImageUrl;

  const ComboCard({
    Key? key,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.defaultImageUrl = 'assets/not-found-image.svg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return SvgPicture.asset(
                    defaultImageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle( fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text('$price \$', style: const TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Expanded( // Flexible ElevatedButton
                      child: SizedBox(
                        width: double.infinity,
                        height: 20,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your "Agregar" button logic here
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF2000B1), backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF2000B1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Agregar',
                            style: TextStyle( fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
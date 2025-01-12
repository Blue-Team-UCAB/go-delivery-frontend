import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/homescreen/bundle_section_placeholder.dart';
import 'package:go_delivery_frontend/presentation/widgets/homescreen/category_tabs_section_placeholder.dart';
import 'package:go_delivery_frontend/presentation/widgets/homescreen/popular_product_section_placeholder.dart';
import 'package:go_delivery_frontend/presentation/widgets/placeholders/text_placeholder.dart';
import 'package:shimmer/shimmer.dart';


class HomescreenPlaceholder extends StatelessWidget {
  const HomescreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEAED),
      body: Container(
        color: const Color(0x55d8d5dd),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 0),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEBEAED),
                      ),
                      child: _buildContent(),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: _getLocationBarPosition(context),
                left: 16,
                right: 16,
                child: Shimmer.fromColors(
                  baseColor: const Color(0xFFd8d5dd),
                  highlightColor: const Color(0xFFF4F4F4),
                  child: Container(
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFd8d5dd),
                      borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0x55d8d5dd),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
        ),
        height: 80,
      ),
    );
  }

  double _getLocationBarPosition(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.1;
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0x55d8d5dd),
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 50),
      height: 120,
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView( // Aquí agregamos el ScrollController
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CategoryTabsSectionPlaceholder(),
            const SizedBox(height: 4),
            //Placeholder del titulo de Combos
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: const TextPlaceholder(height: 18,width: 160,)
            ),
            const SizedBox(height: 19),
            const BundleSectionPlaceholder(),
            const SizedBox(height: 14),//Separacion entre secciones
            //Placeholder del titulo de Populares
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: const TextPlaceholder(height: 18,width: 220,)
            ),
            const SizedBox(height: 18),
            const PopularProductSectionPlaceholder(),
          ],
        ),
      ),
    );
  }
  }















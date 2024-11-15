import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_detail/bundle_detail_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_detail/bundle_detail_state.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_detail/bundle_detail_event.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/presentation/widgets/bundle_card.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/cart/add_bundle_carrito_button.dart';

class BundleDetailScreen extends StatelessWidget {
  static const name = 'bundle-detail-screen';

  final String bundleId;

  final Bundle bundleTest = Bundle(
    id: '057259f8-c42b-4c3f-ac5a-d27b809d764d', 
    name: "combo fiestero", 
    description: "Llevate 3 doritos con 2 pepsi", 
    currency: 'USD', 
    price: 12, 
    stock: 2, 
    weight: 2.45, 
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwTPyzqVBSXWNlO05RXeRe0K-xp1mXNsbXsg&s', 
    caducityDate: DateTime(1), 
    products: []
  );

  BundleDetailScreen({super.key, required this.bundleId});

  @override
  Widget build(BuildContext context) {
    final bundleDetailBloc = context.read<BundleDetailBloc>();
    bundleDetailBloc.add(LoadBundleDetail(bundleId: bundleId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.pop();
            },
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: BlocBuilder<BundleDetailBloc, BundleDetailState>(
          builder: (context, state) {
            if (state is BundleDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BundleDetailLoaded) {
              final bundle = state.bundle;

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      bundle!.imageUrl,
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                      height: 400,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bundle.name,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${bundle.price}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          bundle.description,
                          maxLines: 2,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Peso:  ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${bundle.weight}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Categorias:',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          children: [Text('CHUCHERIAS'), Text('  BOTANA')],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Productos Relacionados:',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 200,
                                height: 255,
                                child: BundleCard(bundle:bundleTest),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 200,
                                height: 255,
                                child: BundleCard(bundle:bundleTest),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 200,
                                height: 255,
                                child: BundleCard(bundle:bundleTest),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            if (state is BundleDetailFailed) {
              return Center(
                child: Text(
                  'Error: ${state.result}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return const Center(child: Text('Estado desconocido'));
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFFFFFFF),
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<BundleDetailBloc, BundleDetailState>(
          builder: (context, state) {
            if (state is BundleDetailLoaded) {
              final bundle = state.bundle;
              return AddBundleCarritoButton(bundle:bundle);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

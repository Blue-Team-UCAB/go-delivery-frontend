import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_detail/bundle_detail_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_detail/bundle_detail_state.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_detail/bundle_detail_event.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/product/product_mapper.dart';
import 'package:go_delivery_frontend/presentation/widgets/card.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/cart/add_bundle_carrito_button.dart';

class BundleDetailScreen extends StatelessWidget {
  static const name = 'bundle-detail-screen';

  final String bundleId;

  const BundleDetailScreen({super.key, required this.bundleId});

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
              final int discount = (bundle?.discounts!.isNotEmpty ?? true)? bundle!.discounts![0].percentage.round() : 0;
              String imageUrl = (bundle?.images.first.isNotEmpty ?? false)
                  ? bundle!.images.first
                  : 'https://via.placeholder.com/150';

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        height: 400,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network('https://via.placeholder.com/150');
                        },
                      ),
                    ),
                    SizedBox(height: 12,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bundle?.name ?? 'Nombre no disponible',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            (bundle?.discounts!.isNotEmpty ?? true)?
                            Text(
                              '\$${(bundle!.price*(1-(discount)/100)).toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF000000)),
                            ):SizedBox(),
                            SizedBox(width: 5,),
                            Text(
                              '\$${bundle?.price ?? 0.0}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                decoration: discount == 0 ? TextDecoration.none: TextDecoration.lineThrough,
                                decorationColor: Color(0x55FF0000),
                                color: discount == 0 ? Color(0xFF000000):Color(0x55FF0000)),
                            ),
                            Expanded(child: SizedBox()),
                            (bundle?.discounts!.isNotEmpty ?? true)?
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 2,horizontal: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                color: Color(0x22FF0000)
                              ),
                              child: Text(
                                '-$discount%',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  color: Color(0x55FF0000)
                                )
                              ),
                            ):SizedBox(),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          bundle?.description ?? 'Descripción no disponible',
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
                              '${bundle?.weight ?? 0.0}',
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
                          'Productos del combo:',
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
                              if (bundle?.products != null)
                                ...bundle!.products!.map((product) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: SizedBox(
                                      width: 200,
                                      height: 255,
                                      child: ProductCard(product: ProductMapper.fromBundleProduct(product)),
                                    ),
                                  );
                                }),
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
              return AddBundleCarritoButton(bundle: bundle);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

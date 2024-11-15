import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/bundle_card.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_state.dart';
import 'package:go_delivery_frontend/presentation/screens/detail/bundle_detail_screen.dart';

class ComboSection extends StatefulWidget {
  const ComboSection({super.key});

  @override
  State<ComboSection> createState() => _ComboSectionState();
}

class _ComboSectionState extends State<ComboSection> {
  @override
  void initState() {
    super.initState();
    // Llamar al evento para cargar los bundles cuando el widget se monta
    context.read<BundleListBloc>().add(const LoadBundleList(page: 1, take: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
          BlocBuilder<BundleListBloc, BundleListState>(
            builder: (context, state) {
              if (state is BundleListLoading) {
                return const Center(child: CircularProgressIndicator());
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
                        GestureDetector(
                          onTap: () {
                            // Navegar al detalle del bundle cuando se selecciona
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BundleDetailScreen(bundleId: bundle.id),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 200,
                            height: 280,
                            child: BundleCard(bundle: bundle),
                          ),
                        ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

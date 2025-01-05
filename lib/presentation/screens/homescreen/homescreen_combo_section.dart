import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/bundle_card.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_state.dart';
import 'package:go_delivery_frontend/presentation/widgets/homescreen/bundle_section_placeholder.dart';

class ComboSection extends StatefulWidget {
  const ComboSection({super.key});

  @override
  State<ComboSection> createState() => _ComboSectionState();
}

class _ComboSectionState extends State<ComboSection> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BundleListBloc>(context).add(
        const LoadBundleList(page: 1, perpage: 4)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
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
                          const SizedBox(width: 20)
                          ]
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

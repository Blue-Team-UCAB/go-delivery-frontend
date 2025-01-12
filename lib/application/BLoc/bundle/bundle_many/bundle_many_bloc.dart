import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_state.dart';
import 'package:go_delivery_frontend/application/use_cases/bundle/get_many_bundle.dart';

class BundleListBloc extends Bloc<BundleListEvent, BundleListState> {
  final GetBundlesUseCase _getBundlesUseCase;

  BundleListBloc(this._getBundlesUseCase) : super(BundleListInitial()) {
    on<LoadBundleList>(_onLoadBundleList);
  }

  Future<void> _onLoadBundleList(
    LoadBundleList event,
    Emitter<BundleListState> emit,
  ) async {
    if (state is BundleListInitial || state is BundleListLoaded) {
      try {
        final currentState = state is BundleListLoaded
            ? state as BundleListLoaded
            : const BundleListLoaded(
                bundles: [], hasReachedMax: false, page: 1);

        emit(BundleListLoading(currentState.bundles));

        final result = await _getBundlesUseCase.execute(
          GetBundlesUseCaseInput(
            page: event.page,
            perpage: event.perpage,
            categories: event.categories ?? [''],
            name: event.name ?? '',
            price: event.price ?? 0,
            popular: event.popular ?? '',
            discount: event.discount ?? '',
          ),
        );

        if (result.isSuccessful()) {
          final newBundles = result.getValue();
          final hasReachedMax = newBundles.isEmpty;

          emit(BundleListLoaded(
            bundles: [...currentState.bundles, ...newBundles],
            hasReachedMax: hasReachedMax,
            page: event.page,
          ));
        } else {
          emit(BundleListFailed(result));
        }
      } catch (e) {
        emit(BundleListFailed(Result.fail(BadReponseFailure())));
      }
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_detail/bundle_detail_event.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_detail/bundle_detail_state.dart';
import 'package:go_delivery_frontend/application/use_cases/bundle/get_one_bundle.dart';

class BundleDetailBloc extends Bloc<BundleDetailEvent, BundleDetailState> {
  final GetOneBundleUseCase _getOneBundleUseCase;

  BundleDetailBloc(this._getOneBundleUseCase) : super(BundleDetailInitial()) {
    on<LoadBundleDetail>(_onLoadBundleDetail);
  }

  Future<void> _onLoadBundleDetail(
    LoadBundleDetail event,
    Emitter<BundleDetailState> emit,
  ) async {
    if (state is BundleDetailInitial || state is BundleDetailLoaded) {
      try {
        final currentState = state is BundleDetailLoaded
            ? state
            : const BundleDetailLoading(null);

        emit(BundleDetailLoading(currentState.bundle));

        final result = await _getOneBundleUseCase.execute(
          GetOneBundleUseCaseInput(bundleId: event.bundleId),
        );

        if (result.isSuccessful()) {
          final bundle = result.getValue();

          // Imprimir la data de los productos del bundle
          print('Productos en el bundle:');
          bundle.products.forEach((product) {
            print('Producto: ${product.name}, URL imagen: ${product.imageUrl}');
          });

          // Si la URL de la imagen está vacía, asignar la imagen predeterminada
          if (bundle.imageUrl.isEmpty) {
            bundle.imageUrl = 'https://via.placeholder.com/150';
          }

          emit(BundleDetailLoaded(bundle));
        } else {
          emit(BundleDetailFailed(result));
        }
      } catch (e) {
        print('Error in BundleDetailBloc: $e');
        emit(BundleDetailFailed(Result.fail(e.toString() as Failure)));
      }
    }
  }
}

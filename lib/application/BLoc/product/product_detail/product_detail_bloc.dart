import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/application/use_cases/product/get_one_product.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_detail/product_detail_event.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_detail/product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetOneProductUseCase _getOneProductUseCase;

  ProductDetailBloc(this._getOneProductUseCase)
      : super(ProductDetailInitial()) {
    on<LoadProductDetail>(_onLoadProductDetail);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state is ProductDetailInitial || state is ProductDetailLoaded) {
      try {
        final currentState = state is ProductDetailLoaded
            ? state
            : const ProductDetailLoading(null);

        emit(ProductDetailLoading(currentState.product));

        final result = await _getOneProductUseCase.execute(
          GetOneProductUseCaseInput(productId: event.productId),
        );

        if (result.isSuccessful()) {
          final product = result.getValue();
          emit(ProductDetailLoaded(product));
        } else {
          emit(ProductDetailFailed(result));
        }
      } catch (e) {
        emit(ProductDetailFailed(Result.fail(e.toString() as Failure)));
      }
    }
  }
}

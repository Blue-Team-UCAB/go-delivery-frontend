import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';

import '../../../../domain/entities/cart/cartitem.dart';
import '../../../../domain/entities/product/product.dart';
import '../../../../domain/repositories/cart/cart_local_storage_repository.dart';
import '../../../core/bloc/ensure_bloc.dart';
import '../../../use_cases/coupon/get_one_coupon.dart';
import '../../../use_cases/order/create_order.dart';
import 'order_create_event.dart';
import 'order_create_state.dart';

class CheckoutBloc extends SafeBloc<CheckoutEvent, CheckoutState> {
  final CartLocalStorageRepository cartRepository;
  final CheckoutUseCase _checkoutUseCase;
  final GetOneCouponUseCase _getOneCouponUseCase;

  CheckoutBloc({
    required CartLocalStorageRepository cartRepository,
    required CheckoutUseCase checkoutUseCase,
    required GetOneCouponUseCase getOneCouponUseCase,
  })  : cartRepository = cartRepository,
        _checkoutUseCase = checkoutUseCase,
        _getOneCouponUseCase = getOneCouponUseCase,
        super(const CheckoutState()) {
    on<LoadCartItemsEvent>(_onLoadCartItems);
    on<ApplyCouponEvent>(_onApplyCoupon);
    on<ProcessCheckoutEvent>(_onProcessCheckout);
  }

  Future<void> _onLoadCartItems(
      LoadCartItemsEvent event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      final cartItems = await cartRepository.loadCartItems();

      // Segregate items by type
      final List<CartItem> productItems = cartItems
          .where((item) => item.type == 'product')
          .toList();

      final List<CartItem> bundleItems = cartItems
          .where((item) => item.type == 'bundle')
          .toList();

      // Calculate total for product items
      double productTotal = 0.0;
      for (var item in productItems) {
        productTotal += item.price * item.quantity;
      }

      // Calculate total for bundle items
      double bundleTotal = 0.0;
      for (var item in bundleItems) {
        bundleTotal += item.price * item.quantity;
      }

      // Calculate overall total
      double total = productTotal + bundleTotal;

      emit(state.copyWith(
        cartItems: cartItems,
        productItems: productItems,
        bundleItems: bundleItems,
        productTotal: productTotal,
        bundleTotal: bundleTotal,
        total: total,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to load cart items',
      ));
    }
  }

  Future<void> _onApplyCoupon(
      ApplyCouponEvent event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      // Fetch coupon
      final input = GetOneCouponUseCaseInput(couponId: event.couponId);
      final couponResult = await _getOneCouponUseCase.execute(input);

      if (!couponResult.isSuccessful()) {
        // Handling failure
        emit(state.copyWith(
          errorMessage: couponResult.getError().message ?? 'Invalid coupon',
        ));
      } else {
        // Handling success
        final coupon = couponResult.getValue();

        // Apply percentage coupon logic
        double discountedTotal = state.total * (1 - (coupon.porcentage / 100));

        emit(state.copyWith(
          appliedCoupon: coupon,
          total: discountedTotal,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to apply coupon',
      ));
    }
  }

  Future<void> _onProcessCheckout(
      ProcessCheckoutEvent event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      // Prepare checkout input using CheckoutProduct and CheckoutBundle directly
      final checkoutInput = CheckoutUseCaseInput(
        direction: event.direction,
        longitude: event.longitude,
        latitude: event.latitude,
        tokenStripe: event.tokenStripe,
        idCoupon: state.appliedCoupon?.id,
        products: event.productItems,
        bundles: event.bundleItems,
      );

      // Rest of the checkout process remains the same
      final orderResult = await _checkoutUseCase.execute(checkoutInput);

      // Handle order creation result
      if (!orderResult.isSuccessful()) {
        emit(state.copyWith(
          errorMessage: orderResult.getError().message ?? 'Failed to create order',
        ));
      } else {
        // Clear cart after successful order
        await cartRepository.emptyCart();

        emit(CheckoutState(
          cartItems: [],
          productItems: [],
          bundleItems: [],
          total: 0.0,
          productTotal: 0.0,
          bundleTotal: 0.0,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to process checkout',
      ));
    }
  }
}
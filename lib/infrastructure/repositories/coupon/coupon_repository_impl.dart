import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';
import 'package:go_delivery_frontend/domain/repositories/coupon/coupon_repository.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/coupon/coupon_mapper.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/result.dart';

import 'package:go_delivery_frontend/application/api/api_request.dart';

class CouponRepositoryImpl extends CouponRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  CouponRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  Future<void> _addAuthorizationHeader() async {
    final token = await _localStorage.getAuthorizationToken();
    _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  }

  @override
  Future<Result<Coupon>> getCouponById(String couponId) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/api/coupon/claim-coupon',
        'POST',
        body: CouponMapper.toJson(couponId),
        (data) {
          final coupon = CouponMapper.fromJson(data);
          print(coupon);
          return coupon;
        },
      );
      return response;
    } catch (e) {
      print('Error in CouponRepositoryImpl.getCouponById: $e');
      rethrow;
    }
  }

  @override
  Future<Result<List<Coupon>>> getCoupons() async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/api/coupon/applicable',
        'GET',
        (data) => CouponMapper.fromJsonList(data['coupons'])
      );

      if (response.isSuccessful()) {

        final coupons = response.getValue();
        print('la respuesta es: ${coupons}');
        return Result.success(coupons);
      } else {
        print('entro en error');
        final error = response.getError();
        return Result.fail(
            ServerFailure(message: 'Error al obtener cupones: $error'));
      }
    } catch (e) {
      print('Error in CouponRepositoryImpl.getCoupons: $e');
      return Result.fail(
          ServerFailure(message: 'Failed to fetch coupons: $e'));
    }
  }
}

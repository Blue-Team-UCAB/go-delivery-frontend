import '../../../core/common/validator.dart';

class loginValidator {

  static final passwordValidator = Validator<String>(rules: [
    Validator.required(
      failure: ValidationFailure('La contraseña es requerida'),
    ),
  ]);

  static final emailValidator = Validator<String>(rules: [
    Validator.required(
      failure: ValidationFailure('El correo electrónico es requerido'),
    ),
    Validator.email(),
  ]);


}
import '../../../core/common/validator.dart';

class loginValidator {

  static final passwordValidator = Validator<String>(rules: [
    Validator.required(
      failure: ValidationFailure('La contraseña es requerida'),
    ),
    Validator.minLength(
      6,
      failure: ValidationFailure('La contraseña debe tener al menos 6 caracteres'),
    ),
    Validator.regex(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&/#_.,:;()\-+])[A-Za-z\d@$!%*?&/#_.,:;()\-+]+$',
      failure: ValidationFailure(
        'Debe contener mayúsculas, minúsculas, números y caracteres especiales',
      ),
    ),
  ]);

  static final emailValidator = Validator<String>(rules: [
    Validator.required(
      failure: ValidationFailure('El correo electrónico es requerido'),
    ),
    Validator.email(),
  ]);


}
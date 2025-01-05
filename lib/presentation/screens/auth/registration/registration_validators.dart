import 'package:go_delivery_frontend/presentation/core/common/validator.dart';

class registrationValidator {
  static final passwordValidator = Validator<String>(rules: [
    Validator.required(
      failure: ValidationFailure('La contraseña es requerida'),
    ),
    Validator.minLength(
      8,
      failure:
          ValidationFailure('La contraseña debe tener al menos 8 caracteres'),
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

  static final usernameValidator = Validator<String>(rules: [
    Validator.required(
      failure: ValidationFailure('El nombre de usuario es requerido'),
    ),
  ]);

  static final phoneValidator = Validator<String>(rules: [
    Validator.required(
      failure: ValidationFailure('El numero de telefono es requerido'),
    ),
    Validator.minLength(
      9,
      failure:
          ValidationFailure('El telefono debe tener al menos 9 caracteres'),
    ),
    Validator.phone(),
  ]);
}

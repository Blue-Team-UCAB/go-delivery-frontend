import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';

class ValidationRule<T> {
  final Failure failure;
  final bool Function(T? value) isValid;

  ValidationRule({
    required this.failure,
    required this.isValid,
  });
}

class Validator<T> {
  final List<ValidationRule<T>> rules;

  Validator({required this.rules});

  Result<T> validate(T? value) {
    for (var rule in rules) {
      if (!rule.isValid(value)) {
        return Result.fail(rule.failure);
      }
    }
    return Result.success(value as T);
  }

  static ValidationRule<String> required({
    Failure? failure,
  }) {
    return ValidationRule<String>(
      failure: failure ?? ValidationFailure('Este campo es requerido'),
      isValid: (value) => value != null && value.isNotEmpty,
    );
  }

  static ValidationRule<String> minLength(
      int length, {
        Failure? failure,
      }) {
    return ValidationRule<String>(
      failure: failure ?? ValidationFailure('Debe tener al menos $length caracteres'),
      isValid: (value) => value != null && value.length >= length,
    );
  }

  static ValidationRule<String> maxLength(
      int length, {
        Failure? failure,
      }) {
    return ValidationRule<String>(
      failure: failure ?? ValidationFailure('No debe exceder $length caracteres'),
      isValid: (value) => value != null && value.length <= length,
    );
  }

  static ValidationRule<String> email({
    Failure? failure,
  }) {
    return ValidationRule<String>(
      failure: failure ?? ValidationFailure('Ingrese un correo electrónico válido'),
      isValid: (value) => value != null && RegExp(
        r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      ).hasMatch(value),
    );
  }

  static ValidationRule<String> phone({
    Failure? failure,
    int minLength = 10,
  }) {
    return ValidationRule<String>(
      failure: failure ?? ValidationFailure('Ingrese un número de teléfono válido'),
      isValid: (value) => value != null &&
          value.length >= minLength &&
          RegExp(r'^\d+$').hasMatch(value),
    );
  }

  static ValidationRule<String> regex(
      String pattern, {
        required Failure failure,
      }) {
    return ValidationRule<String>(
      failure: failure,
      isValid: (value) => value != null && RegExp(pattern).hasMatch(value),
    );
  }
}

class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}
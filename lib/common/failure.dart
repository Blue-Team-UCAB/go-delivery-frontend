abstract class Failure {
  final String message;
  const Failure(this.message);
}

class CustomFailure extends Failure {
  const CustomFailure({String message = '<CUSTOM FAILURE ARROJADO>'})
      : super(message);
}

class NoSessionFailure extends Failure {
  const NoSessionFailure({String message = 'No existe una sesión iniciada'})
      : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure(
      {String message =
          'Estamos experimentando ciertos problemas. Inténtalo de nuevo más tarde'})
      : super(message);
}

class BadReponseFailure extends Failure {
  BadReponseFailure(
      {String message =
      'Fallo en la Respuesta del Servidor dado datos por el Cliente'})
      : super(message);
}

class NoAuthorizeFailure extends Failure {
  const NoAuthorizeFailure(
      {String message =
      'Autenticación No Autorizada'})
      : super(message);
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({String message = 'No conexion a internet'})
      : super(message);
}

class UnnableToCheckLocationFailure extends Failure {
  const UnnableToCheckLocationFailure({String message = 'Problemas en Localizar la Ubicación'})
      : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure() : super('Oppss!! Algo salió mal, inténtalo de nuevo');
}

abstract class Failure {
  const Failure(this.message);
  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A apărut o eroare pe server.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Nu s-a putut conecta la rețea. Verifică conexiunea la internet.',
  ]);
}

class ParseFailure extends Failure {
  const ParseFailure([
    super.message = 'Eroare la procesarea datelor JSON de la server.',
  ]);
}

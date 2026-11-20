class ServerException implements Exception {
  ServerException([this.message = 'A apărut o eroare pe server.']);
  final String message;

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  NetworkException([this.message = 'Eroare de rețea. Verifică conexiunea la internet (Wi-Fi).']);
  final String message;

  @override
  String toString() => message;
}

class ParseException implements Exception {
  ParseException([this.message = 'Eroare la procesarea datelor de la server.']);
  final String message;

  @override
  String toString() => message;
}

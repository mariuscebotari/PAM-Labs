class ServerException implements Exception {
  ServerException([this.message = 'Server Error']);
  final String message;
}

class NetworkException implements Exception {
  NetworkException([this.message = 'Network Error']);
  final String message;
}

class ParseException implements Exception {
  ParseException([this.message = 'Parse Error']);
  final String message;
}

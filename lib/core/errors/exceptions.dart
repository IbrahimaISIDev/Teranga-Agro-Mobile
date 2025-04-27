class OfflineException implements Exception {
  final String message = 'Pas de connexion, données enregistrées localement';
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}
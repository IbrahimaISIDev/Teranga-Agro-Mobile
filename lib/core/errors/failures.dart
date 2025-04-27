abstract class Failure {
  final String message;
  Failure(this.message);
}

class OfflineFailure extends Failure {
  OfflineFailure() : super('Hors-ligne, données enregistrées localement');
  // OfflineFailure() : super('No internet connection');
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}
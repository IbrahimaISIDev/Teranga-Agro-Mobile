import 'package:flutter/material.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';

class ProfileProvider with ChangeNotifier {
  final GetUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;

  ProfileProvider(this.getUserUseCase, this.updateUserUseCase);

  User? _user;
  bool _isLoading = false;
  bool _isOffline = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();

    final result = await getUserUseCase();
    result.fold(
      (failure) {
        _isOffline = failure is OfflineFailure;
        _errorMessage = failure.message;
        _user = null;
      },
      (user) {
        _user = user;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUser(User user) async {
    _isLoading = true;
    notifyListeners();

    final result = await updateUserUseCase(user);
    bool success = result.isRight();

    if (success) {
      _user = user;
      _errorMessage = null;
    } else {
      _errorMessage = result.fold((failure) => failure.message, (_) => null);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
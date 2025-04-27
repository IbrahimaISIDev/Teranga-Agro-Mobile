import 'dart:async';
import 'package:flutter/material.dart';
import '../../../dashboard/domain/entities/dashboard_stats.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/parcelle.dart';
import '../../domain/entities/culture.dart';
import '../../domain/entities/suivi.dart';
import '../../domain/usecases/get_parcelles_usecase.dart';
import '../../domain/usecases/add_parcelle_usecase.dart';
import '../../domain/usecases/update_parcelle_usecase.dart';
import '../../domain/usecases/delete_parcelle_usecase.dart';
import '../../domain/usecases/add_culture_usecase.dart';
import '../../domain/usecases/update_culture_usecase.dart';
import '../../domain/usecases/delete_culture_usecase.dart';
import '../../domain/usecases/add_suivi_usecase.dart';
import '../../../dashboard/domain/usecases/get_dashboard_stats_usecase.dart';

class ParcelleProvider with ChangeNotifier {
  final GetParcellesUseCase getParcellesUseCase;
  final AddParcelleUseCase addParcelleUseCase;
  final UpdateParcelleUseCase updateParcelleUseCase;
  final DeleteParcelleUseCase deleteParcelleUseCase;
  final AddCultureUseCase addCultureUseCase;
  final UpdateCultureUseCase updateCultureUseCase;
  final DeleteCultureUseCase deleteCultureUseCase;
  final AddSuiviUseCase addSuiviUseCase;
  final GetDashboardStatsUseCase getDashboardStatsUseCase;

  ParcelleProvider(
    this.getParcellesUseCase,
    this.addParcelleUseCase,
    this.updateParcelleUseCase,
    this.deleteParcelleUseCase,
    this.addCultureUseCase,
    this.updateCultureUseCase,
    this.deleteCultureUseCase,
    this.addSuiviUseCase,
    this.getDashboardStatsUseCase,
  );

  List<Parcelle> _parcelles = [];
  Map<int, List<Culture>> _cultures = {};
  Map<int, List<Suivi>> _suivis = {};
  DashboardStats? _dashboardStats;
  bool _isLoading = false;
  bool _isOffline = false;
  String? _errorMessage;
  Timer? _debounceTimer;

  List<Parcelle> get parcelles => _parcelles;
  List<Culture> getCultures(int parcelleId) => _cultures[parcelleId] ?? [];
  List<Suivi> getSuivis(int cultureId) => _suivis[cultureId] ?? [];
  DashboardStats? get dashboardStats => _dashboardStats;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get errorMessage => _errorMessage;

  Future<void> fetchParcelles() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    final result = await getParcellesUseCase();
    result.fold(
      (failure) {
        _isOffline = failure is OfflineFailure;
        _errorMessage = failure.message;
        _parcelles = [];
      },
      (parcelles) {
        _parcelles = parcelles;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addParcelle(
      String nom, double surface, double? latitude, double? longitude) async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();

    final parcelle =
        Parcelle(id: 0, nom: nom, surface: surface, latitude: latitude, longitude: longitude);
    final result = await addParcelleUseCase(parcelle);
    bool success = result.isRight();

    if (success) {
      await fetchParcelles();
      await fetchDashboardStats(debounce: false); // Appel immédiat après ajout
    } else {
      _errorMessage = result.fold((failure) => failure.message, (_) => null);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> updateParcelle(Parcelle parcelle) async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();

    final result = await updateParcelleUseCase(parcelle);
    bool success = result.isRight();

    if (success) {
      await fetchParcelles();
      await fetchDashboardStats(debounce: false); // Appel immédiat après mise à jour
    } else {
      _errorMessage = result.fold((failure) => failure.message, (_) => null);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> deleteParcelle(int id) async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();

    final result = await deleteParcelleUseCase(id);
    bool success = result.isRight();

    if (success) {
      await fetchParcelles();
      _cultures.remove(id);
      _suivis.removeWhere((key, value) =>
          _cultures.values.any((cultures) => cultures.any((culture) => culture.id == key)));
      await fetchDashboardStats(debounce: false); // Appel immédiat après suppression
    } else {
      _errorMessage = result.fold((failure) => failure.message, (_) => null);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> fetchCultures(int parcelleId) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    final result = await addCultureUseCase.repository.getCultures(parcelleId);
    result.fold(
      (failure) {
        _isOffline = failure is OfflineFailure;
        _errorMessage = failure.message;
        _cultures[parcelleId] = [];
      },
      (cultures) {
        _cultures[parcelleId] = cultures;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addCulture(
      int parcelleId, String nom, String type, String datePlantation) async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();

    final culture =
        Culture(id: 0, parcelleId: parcelleId, nom: nom, type: type, datePlantation: datePlantation);
    final result = await addCultureUseCase(culture);
    bool success = result.isRight();

    if (success) {
      await fetchCultures(parcelleId);
      await fetchDashboardStats(debounce: false); // Appel immédiat après ajout
    } else {
      _errorMessage = result.fold((failure) => failure.message, (_) => null);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> updateCulture(Culture culture) async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();

    final result = await updateCultureUseCase(culture);
    bool success = result.isRight();

    if (success) {
      await fetchCultures(culture.parcelleId);
      await fetchDashboardStats(debounce: false); // Appel immédiat après mise à jour
    } else {
      _errorMessage = result.fold((failure) => failure.message, (_) => null);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> deleteCulture(int id, int parcelleId) async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();

    final result = await deleteCultureUseCase(id);
    bool success = result.isRight();

    if (success) {
      await fetchCultures(parcelleId);
      _suivis.remove(id);
      await fetchDashboardStats(debounce: false); // Appel immédiat après suppression
    } else {
      _errorMessage = result.fold((failure) => failure.message, (_) => null);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> fetchSuivis(int cultureId) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    final result = await addSuiviUseCase.repository.getSuivis(cultureId);
    result.fold(
      (failure) {
        _isOffline = failure is OfflineFailure;
        _errorMessage = failure.message;
        _suivis[cultureId] = [];
      },
      (suivis) {
        _suivis[cultureId] = suivis;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addSuivi(int cultureId, String type, String date, String? notes) async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();

    final suivi = Suivi(id: 0, cultureId: cultureId, type: type, date: date, notes: notes);
    final result = await addSuiviUseCase(suivi);
    bool success = result.isRight();

    if (success) {
      await fetchSuivis(cultureId);
      await fetchDashboardStats(debounce: false); // Appel immédiat après ajout
    } else {
      _errorMessage = result.fold((failure) => failure.message, (_) => null);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> fetchDashboardStats({bool debounce = true}) async {
    if (_isLoading && debounce) return;

    if (debounce) {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
        await _fetchDashboardStatsCore();
      });
    } else {
      await _fetchDashboardStatsCore();
    }
  }

  Future<void> _fetchDashboardStatsCore() async {
    _isLoading = true;
    notifyListeners();

    final result = await getDashboardStatsUseCase();
    result.fold(
      (failure) {
        _isOffline = failure is OfflineFailure;
        _errorMessage = failure.message;
        _dashboardStats = null;
      },
      (stats) {
        _dashboardStats = stats;
        _errorMessage = null;
      },
    );

    _isLoading = false;

    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
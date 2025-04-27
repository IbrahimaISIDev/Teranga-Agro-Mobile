import '../../../parcelle/domain/entities/suivi.dart';

class DashboardStats {
  final int parcellesCount;
  final int culturesCount;
  final List<Suivi> recentSuivis;

  DashboardStats({
    required this.parcellesCount,
    required this.culturesCount,
    required this.recentSuivis,
  });
}
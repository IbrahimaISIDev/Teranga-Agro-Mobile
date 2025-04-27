import 'package:teranga_agro/features/parcelle/data/models/parcelle_model.dart';

abstract class ParcelleLocalDataSource {
  Future<List<ParcelleModel>> getParcelles();
  Future<void> addParcelle(ParcelleModel parcelle);
  // Future<void> insertDummyData();
}
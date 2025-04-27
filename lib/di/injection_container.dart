import 'package:get_it/get_it.dart';
import 'package:teranga_agro/core/providers/locale_provider.dart';
import 'package:teranga_agro/core/theme/theme_provider.dart';
import 'package:teranga_agro/core/network/network_info.dart';
import 'package:teranga_agro/core/storage/database.dart';
import 'package:teranga_agro/core/network/queue.dart';
import 'package:teranga_agro/features/marketplace/data/datasources/marketplace_local_data_source.dart';
import 'package:teranga_agro/features/marketplace/data/repositories/marketplace_repository_impl.dart' as marketplace_repo; // Alias for repository
import 'package:teranga_agro/features/marketplace/domain/repositories/marketplace_repository.dart';
import 'package:teranga_agro/features/marketplace/domain/usecases/add_product_usecase.dart';
import 'package:teranga_agro/features/marketplace/domain/usecases/get_orders_usecase.dart';
import 'package:teranga_agro/features/marketplace/domain/usecases/get_products_usecase.dart';
import 'package:teranga_agro/features/marketplace/domain/usecases/update_order_status_usecase.dart';
import 'package:teranga_agro/features/marketplace/domain/usecases/update_product_usecase.dart';
import 'package:teranga_agro/features/marketplace/presentation/providers/marketplace_provider.dart';
import 'package:teranga_agro/features/parcelle/data/datasources/parcelle_local_data_source.dart';
import 'package:teranga_agro/features/parcelle/data/repositories/parcelle_repository_impl.dart';
import 'package:teranga_agro/features/parcelle/domain/repositories/parcelle_repository.dart';
import 'package:teranga_agro/features/parcelle/domain/usecases/get_parcelles_usecase.dart';
import 'package:teranga_agro/features/parcelle/domain/usecases/add_parcelle_usecase.dart';
import 'package:teranga_agro/features/parcelle/domain/usecases/update_parcelle_usecase.dart';
import 'package:teranga_agro/features/parcelle/domain/usecases/delete_parcelle_usecase.dart';
import 'package:teranga_agro/features/parcelle/domain/usecases/add_culture_usecase.dart';
import 'package:teranga_agro/features/parcelle/domain/usecases/update_culture_usecase.dart';
import 'package:teranga_agro/features/parcelle/domain/usecases/delete_culture_usecase.dart';
import 'package:teranga_agro/features/parcelle/domain/usecases/add_suivi_usecase.dart';
import 'package:teranga_agro/features/parcelle/presentation/providers/parcelle_provider.dart';
import 'package:teranga_agro/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:teranga_agro/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:teranga_agro/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:teranga_agro/features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:teranga_agro/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:teranga_agro/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:teranga_agro/features/profile/domain/repositories/profile_repository.dart';
import 'package:teranga_agro/features/profile/domain/usecases/get_user_usecase.dart';
import 'package:teranga_agro/features/profile/domain/usecases/update_user_usecase.dart';
import 'package:teranga_agro/features/profile/presentation/providers/profile_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  try {
    // Core
    sl.registerLazySingleton(() => Connectivity());
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
    sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
    sl.registerLazySingleton(() => QueueManager(sl()));

    // Parcelle
    sl.registerLazySingleton<ParcelleLocalDataSource>(
        () => ParcelleLocalDataSourceImpl(databaseHelper: sl()));
    sl.registerLazySingleton<ParcelleRepository>(() => ParcelleRepositoryImpl(sl(), sl(), sl()));
    sl.registerLazySingleton(() => GetParcellesUseCase(sl()));
    sl.registerLazySingleton(() => AddParcelleUseCase(sl()));
    sl.registerLazySingleton(() => UpdateParcelleUseCase(sl()));
    sl.registerLazySingleton(() => DeleteParcelleUseCase(sl()));
    sl.registerLazySingleton(() => AddCultureUseCase(sl()));
    sl.registerLazySingleton(() => UpdateCultureUseCase(sl()));
    sl.registerLazySingleton(() => DeleteCultureUseCase(sl()));
    sl.registerLazySingleton(() => AddSuiviUseCase(sl()));

    // Dashboard
    sl.registerLazySingleton<DashboardLocalDataSource>(() => DashboardLocalDataSourceImpl());
    sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton(() => GetDashboardStatsUseCase(sl()));

    // Marketplace
    sl.registerLazySingleton<MarketplaceLocalDataSource>(
        () => MarketplaceLocalDataSourceImpl(databaseHelper: sl()));
    sl.registerLazySingleton<MarketplaceRepository>(() => marketplace_repo.MarketplaceRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton(() => GetProductsUseCase(sl()));
    sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
    sl.registerLazySingleton(() => UpdateOrderStatusUseCase(sl()));
    // sl.registerFactory<MarketplaceProvider>(() => MarketplaceProvider(sl(), sl(), sl()));
    sl.registerLazySingleton(() => AddProductUseCase(sl()));
    sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
    sl.registerFactory(() => MarketplaceProvider(sl(), sl(), sl(), sl(), sl()));

     // Profile
    sl.registerLazySingleton<ProfileLocalDataSource>(() => ProfileLocalDataSourceImpl());
    sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton(() => GetUserUseCase(sl()));
    sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
    sl.registerFactory(() => ProfileProvider(sl(), sl()));

    // Providers
    sl.registerFactory(() => ParcelleProvider(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
    sl.registerSingleton<LocaleProvider>(LocaleProvider());
    sl.registerSingleton<ThemeProvider>(ThemeProvider());
  } catch (e, stackTrace) {
    rethrow;
  }
}
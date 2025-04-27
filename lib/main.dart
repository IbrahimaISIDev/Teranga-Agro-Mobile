import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:teranga_agro/features/profile/presentation/providers/profile_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'di/injection_container.dart' as di;
import 'features/parcelle/presentation/providers/parcelle_provider.dart';
import 'features/marketplace/presentation/providers/marketplace_provider.dart';
import 'routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Main: Calling di.init()...');
  await di.init();
  print('Main: di.init() completed.');
  print('Main: Initializing ThemeProvider...');
  await di.sl<ThemeProvider>().loadThemeMode();
  print('Main: ThemeProvider initialized.');
  runApp(const TerangaAgroApp());
}

class TerangaAgroApp extends StatelessWidget {
  const TerangaAgroApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Main: Building TerangaAgroApp...');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          print('Main: Creating LocaleProvider...');
          return di.sl<LocaleProvider>();
        }),
        ChangeNotifierProvider(create: (_) {
          print('Main: Creating ThemeProvider...');
          return di.sl<ThemeProvider>();
        }),
        ChangeNotifierProvider(create: (_) {
          print('Main: Creating ParcelleProvider...');
          return di.sl<ParcelleProvider>();
        }),
        ChangeNotifierProvider(create: (_) {
          print('Main: Creating MarketplaceProvider...');
          return di.sl<MarketplaceProvider>();
        }),
        ChangeNotifierProvider(create: (_) {
          return di.sl<ProfileProvider>();

        }),
      ],
      child: Consumer2<LocaleProvider, ThemeProvider>(
        builder: (context, localeProvider, themeProvider, child) {
          print('Main: Building MaterialApp...');
          return MaterialApp.router(
            title: 'Teranga Agro',
            theme: AppTheme.lightTheme.copyWith(
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                backgroundColor: Colors.white,
              ),
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                backgroundColor: Colors.black,
              ),
            ),
            themeMode: themeProvider.themeMode,
            routerConfig: router,
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('fr', 'FR'),
              Locale('wo', 'SN'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}

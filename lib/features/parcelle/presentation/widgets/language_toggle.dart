import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teranga_agro/core/providers/locale_provider.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return PopupMenuButton<Locale>(
          onSelected: (Locale newLocale) {
            localeProvider.setLocale(newLocale);
          },
          offset: const Offset(0, 40),
          child: _buildFlagIcon(localeProvider.locale),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
            PopupMenuItem<Locale>(
              value: const Locale('en', 'US'),
              child: Row(
                children: [
                  _buildFlagEmoji('🇺🇸'),
                  const SizedBox(width: 8),
                  const Text('English'),
                ],
              ),
            ),
            PopupMenuItem<Locale>(
              value: const Locale('fr', 'FR'),
              child: Row(
                children: [
                  _buildFlagEmoji('🇫🇷'),
                  const SizedBox(width: 8),
                  const Text('Français'),
                ],
              ),
            ),
            PopupMenuItem<Locale>(
              value: const Locale('wo', 'SN'),
              child: Row(
                children: [
                  _buildFlagEmoji('🇸🇳'),
                  const SizedBox(width: 8),
                  const Text('Wolof'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFlagIcon(Locale locale) {
    // Par défaut, afficher le globe
    String flagEmoji = '🌐';
    
    // Si une langue est déjà sélectionnée, afficher le drapeau correspondant
    if (locale.languageCode == 'en' && locale.countryCode == 'US') {
      flagEmoji = '🇺🇸';
    } else if (locale.languageCode == 'fr' && locale.countryCode == 'FR') {
      flagEmoji = '🇫🇷';
    } else if (locale.languageCode == 'wo' && locale.countryCode == 'SN') {
      flagEmoji = '🇸🇳';
    }
    
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: _buildFlagEmoji(flagEmoji),
    );
  }

  Widget _buildFlagEmoji(String emoji) {
    return Text(
      emoji,
      style: const TextStyle(fontSize: 24),
    );
  }
}
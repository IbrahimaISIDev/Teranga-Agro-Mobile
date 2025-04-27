import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MarketplaceHeader extends StatefulWidget {
  const MarketplaceHeader({Key? key}) : super(key: key);

  @override
  _MarketplaceHeaderState createState() => _MarketplaceHeaderState();
}

class _MarketplaceHeaderState extends State<MarketplaceHeader>
    with SingleTickerProviderStateMixin {
  bool _isSearching =
      false; // État pour gérer l'affichage du champ de recherche
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = []; // Suggestions de recherche
  bool _isLoading = false; // Indicateur de chargement

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Affichage conditionnel : titre ou champ de recherche
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isSearching
                    ? Flexible(
                        child: TextField(
                          key: const ValueKey('searchField'),
                          controller: _searchController,
                          style: const TextStyle(
                              color:
                                  Colors.black), // Texte en noir pour contraste
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white
                                .withOpacity(0.8), // Fond blanc avec opacité
                            hintText: loc.searchPlaceholder ?? "Rechercher...",
                            hintStyle: TextStyle(
                              color: Colors.grey[600], // Couleur du placeholder
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Bordures arrondies
                              borderSide:
                                  BorderSide.none, // Pas de bordure visible
                            ),
                          ),
                          onChanged: (value) {
                            _onSearchChanged(value);
                          },
                        ),
                      )
                    : Text(
                        loc.navMarketplace,
                        key: const ValueKey('title'),
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isSearching ? Icons.close : Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          _searchController
                              .clear(); // Réinitialiser la recherche
                          _suggestions.clear(); // Effacer les suggestions
                        }
                      });
                    },
                  ),
                  if (!_isSearching) _buildNotificationIcon(),
                ],
              ),
            ],
          ),
          if (_isSearching) ...[
            const SizedBox(height: 12),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : _buildSuggestions(),
          ] else ...[
            const SizedBox(height: 12),
            Text(
              loc.marketplaceDescription ?? "Gérez vos produits et commandes",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // TODO: Implémenter les notifications
          },
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              '2',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions() {
    if (_suggestions.isEmpty) {
      return Text(
        "Aucune suggestion",
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _suggestions
          .map(
            (suggestion) => ListTile(
              title: Text(
                suggestion,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                // TODO: Implémenter l'action lors de la sélection d'une suggestion
                print("Suggestion sélectionnée : $suggestion");
              },
            ),
          )
          .toList(),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isLoading = true;
    });

    // Simuler une recherche avec un délai
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
        _suggestions = query.isEmpty
            ? []
            : List.generate(5, (index) => "$query suggestion $index");
      });
    });
  }
}
